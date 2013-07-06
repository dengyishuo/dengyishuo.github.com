library(plyr) 
自带数据集mtcars 

```{r}
head(mtcars) 
##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb 
## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4 
## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4 
## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1 
## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1 
## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2 
## Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1 
```
使用mutate代替transform，直接在数据框中生成1个新的数据列
    
```{r}
mtcars.new1 <- mutate(mtcars, wt = wt * 100, qsec10 = qsec * 10) 
head(mtcars.new1) 
##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb 
## Mazda RX4         21.0   6  160 110 3.90 262.0 16.46  0  1    4    4 
## Mazda RX4 Wag     21.0   6  160 110 3.90 287.5 17.02  0  1    4    4 
## Datsun 710        22.8   4  108  93 3.85 232.0 18.61  1  1    4    1 
## Hornet 4 Drive    21.4   6  258 110 3.08 321.5 19.44  1  0    3    1 
## Hornet Sportabout 18.7   8  360 175 3.15 344.0 17.02  0  0    3    2 
## Valiant           18.1   6  225 105 2.76 346.0 20.22  1  0    3    1 
##                   qsec10 
## Mazda RX4          164.6 
## Mazda RX4 Wag      170.2 
## Datsun 710         186.1 
## Hornet 4 Drive     194.4 
## Hornet Sportabout  170.2 
## Valiant            202.2 
```
使用count代替table，方便的对数据框的各列进行汇总 
```{r}
count.cyl.vs.gear <- count(mtcars, c("cyl", "vs", "gear")) 
count.cyl.vs.gear 
##    cyl vs gear freq 
## 1    4  0    5    1 
## 2    4  1    3    1 
## 3    4  1    4    8 
## 4    4  1    5    1 
## 5    6  0    4    2 
## 6    6  0    5    1 
## 7    6  1    3    2 
## 8    6  1    4    2 
## 9    8  0    3   12 
## 10   8  0    5    2 
```
使用arrange代替order，方便的按照多列对数据框进行排序 

```{r}
mtcars.new2 <- arrange(mtcars, cyl, vs, gear) 
head(mtcars.new2) 
##    mpg cyl  disp hp drat    wt  qsec vs am gear carb 
## 1 26.0   4 120.3 91 4.43 2.140 16.70  0  1    5    2 
## 2 21.5   4 120.1 97 3.70 2.465 20.01  1  0    3    1 
## 3 22.8   4 108.0 93 3.85 2.320 18.61  1  1    4    1 
## 4 24.4   4 146.7 62 3.69 3.190 20.00  1  0    4    2 
```
## 5 22.8   4 140.8 95 3.92 3.150 22.90  1  0    4    2 
