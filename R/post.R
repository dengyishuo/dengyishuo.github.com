#!/usr/bin/env Rscript
# 格物堂发文工具：index.Rmd -> index.md
#
# 用法
#   Rscript R/post.R content/blog/2026-11-20-my-slug    编译指定文章
#   Rscript R/post.R --new my-slug                      新建文章骨架
#   Rscript R/post.R --check content/blog/xxx           只检查不改文件
#
# 设计要点
#   1. 先 knit 到临时文件，校验通过才覆盖 index.md。knit() 直接写目标路径时，
#      中途报错会把成品 md 写坏，这里不允许这种情况发生。
#   2. 显式把 fig.path 钉死为 index_files/figure-html/，与历史 147 篇保持一致，
#      Hugo 的 page bundle 才认得出这些图。
#   3. knit 默认 error=TRUE：某块代码报错不会中断，错误会写进正文。
#      所以产物里出现 "## Error" 时这里会警告 —— 多数情况那不是你想要的结果。
#
# 记住：md 是产物。要改内容改 Rmd，改完重跑这条命令。

suppressMessages({
  if (!requireNamespace("knitr", quietly = TRUE)) {
    stop("需要 knitr：install.packages('knitr')")
  }
})

FIG_PATH <- "index_files/figure-html/"

usage <- function() {
  cat(
    "用法:\n",
    "  Rscript R/post.R <文章目录>       编译 index.Rmd -> index.md\n",
    "  Rscript R/post.R --new <slug>     新建文章骨架\n",
    "  Rscript R/post.R --check <目录>   只校验，不写文件\n",
    sep = ""
  )
}

# ---- front matter 读写 -------------------------------------------------------

# 返回 list(front = 字符向量, body_start = 正文首行行号)
split_front <- function(lines) {
  if (length(lines) < 3 || trimws(lines[1]) != "---") {
    stop("文件不是以 --- 开头，没有 front matter")
  }
  rest <- which(trimws(lines[-1]) == "---")
  if (length(rest) == 0) stop("front matter 没有闭合的 ---")
  close_at <- rest[1] + 1L
  list(front = lines[1:close_at], body_start = close_at + 1L)
}

# ---- 主流程 -----------------------------------------------------------------

knit_one <- function(dir, write = TRUE) {
  dir <- sub("/+$", "", dir)
  if (!dir.exists(dir)) stop(sprintf("目录不存在: %s", dir))

  rmd <- file.path(dir, "index.Rmd")
  if (!file.exists(rmd)) stop(sprintf("缺少 index.Rmd: %s", rmd))

  src <- readLines(rmd, warn = FALSE, encoding = "UTF-8")
  src_fm <- tryCatch(split_front(src), error = function(e) {
    stop(sprintf("index.Rmd 的 front matter 有问题：%s", conditionMessage(e)))
  })

  if (any(grepl("^output[[:space:]]*:", src_fm$front))) {
    warning("front matter 里有 output: 字段。knitr::knit() 不认它，" ,
            "只有 rmarkdown::render() 才用 —— 留着容易误以为是它生成的产物。",
            call. = FALSE)
  }

  owd <- setwd(dir)
  on.exit(setwd(owd), add = TRUE)

  knitr::opts_chunk$set(fig.path = FIG_PATH)

  tmp <- tempfile(fileext = ".md")
  on.exit(unlink(tmp), add = TRUE)

  cat(sprintf("-> knit %s\n", rmd))
  ok <- tryCatch(
    {
      knitr::knit("index.Rmd", output = tmp, quiet = TRUE)
      TRUE
    },
    error = function(e) {
      message("knit 失败，index.md 未改动：", conditionMessage(e))
      FALSE
    }
  )
  if (!ok) return(invisible(FALSE))

  md <- readLines(tmp, warn = FALSE, encoding = "UTF-8")

  # 产物自检 ---------------------------------------------------------------
  if (length(md) < 3) stop("产物为空，index.md 未改动")
  md_fm <- tryCatch(split_front(md), error = function(e) {
    stop(sprintf("产物 front matter 异常，index.md 未改动：%s", conditionMessage(e)))
  })

  # front matter 必须与源文件逐字一致，knit 不该动它
  if (!identical(src_fm$front, md_fm$front)) {
    stop("产物 front matter 与 index.Rmd 不一致，index.md 未改动")
  }

  # knit 过程中没被中断，但正文里可能留了错误
  err_lines <- grep("^## Error", md, value = TRUE)
  if (length(err_lines) > 0) {
    warning(sprintf("正文里有 %d 处 ## Error：%s",
                    length(err_lines), err_lines[1]),
            call. = FALSE)
  }

  # 图片盘点 ---------------------------------------------------------------
  figs <- if (dir.exists("index_files")) {
    list.files("index_files", recursive = TRUE, pattern = "\\.(png|jpe?g|svg)$")
  } else {
    character(0)
  }
  used <- regmatches(
    paste(md, collapse = "\n"),
    gregexpr("index_files/[^)\"'[:space:]]+", paste(md, collapse = "\n"))
  )[[1]]
  orphan <- setdiff(figs, sub("^index_files/", "", used))

  if (write) {
    writeLines(md, "index.md", useBytes = TRUE)
    cat(sprintf("   写入 index.md  %.1f KB\n", file.size("index.md") / 1024))
  } else {
    cat("   --check 模式，未写入\n")
  }

  n_chunk <- length(grep("^```\\{", src))
  cat(sprintf("   代码块 %d 个，图片 %d 张\n", n_chunk, length(figs)))

  # 未命名的块会生成 unnamed-chunk-N-1.png：图名没含义，而且在前面插一块
  # 就会让后面所有图集体改名，git 里看着像全量改动。
  if (any(grepl("unnamed-chunk", figs))) {
    cat("   提示：有未命名的代码块。写成 ```{r plot-cars} 这类具名块，\n")
    cat("        图会叫 plot-cars-1.png，插块也不会导致后面图集体改名。\n")
  }

  # slug 统一小写：Hugo 本来会 URLize，但源码里大小写混着不好搜
  slug_line <- grep("^slug:", md_fm$front, value = TRUE)
  if (length(slug_line) == 1) {
    slug_val <- trimws(sub("^slug:", "", slug_line))
    if (grepl("[A-Z]", slug_val)) {
      cat(sprintf("   提示：slug 含大写（%s），建议改全小写。\n", slug_val))
    }
  }
  if (length(orphan) > 0) {
    cat(sprintf("   !! index_files 里有 %d 张图没被引用（可能是旧图残留）：\n",
                length(orphan)))
    cat(paste0("      ", head(orphan, 5), collapse = "\n"), "\n", sep = "")
    if (length(orphan) > 5) cat("       ...\n")
  }

  invisible(TRUE)
}

# ---- 新建文章 ---------------------------------------------------------------

new_post <- function(slug) {
  slug <- tolower(gsub("[^a-zA-Z0-9-]+", "-", slug))
  slug <- gsub("^-+|-+$", "", slug)
  if (!nzchar(slug)) stop("slug 里得有点字母或数字")

  date <- format(Sys.Date(), "%Y-%m-%d")
  dir <- file.path("content/blog", paste0(date, "-", slug))
  if (dir.exists(dir)) stop(sprintf("目录已存在: %s", dir))
  dir.create(dir, recursive = TRUE)

  rmd <- file.path(dir, "index.Rmd")
  writeLines(c(
    "---",
    "title: \"\"",
    "author: MatrixSpk",
    "date: '2026-11-17'",
    sprintf("slug: %s", slug),
    "categories:",
    "- 待分类",
    "tags:",
    "  - r",
    "---",
    "",
    "正文写在这里。",
    "",
    "```{r setup, include=FALSE}",
    "knitr::opts_chunk$set(comment = \"##\")",
    "```",
    "",
    "```{r, message=FALSE, warning=FALSE}",
    "1 + 1",
    "```",
    ""
  ), rmd, useBytes = TRUE)

  cat(sprintf("新建 %s\n", rmd))
  cat("填好 title / date / categories / tags，写完跑：\n")
  cat(sprintf("  Rscript R/post.R %s\n", dir))
  invisible(dir)
}

# ---- 入口 -------------------------------------------------------------------

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  usage()
  quit(status = 1)
}

if (args[1] == "--new") {
  if (length(args) < 2) stop("--new 后面要跟 slug")
  new_post(args[2])
} else if (args[1] == "--check") {
  if (length(args) < 2) stop("--check 后面要跟文章目录")
  knit_one(args[2], write = FALSE)
} else {
  knit_one(args[1], write = TRUE)
}
