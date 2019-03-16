Coursera - Developing Data Products
========================================================
author: Daniel Robinett
date: 3/16/19
autosize: true

My first Interactive Shiny App and Presentation
========================================================

For more details on authoring R presentations please visit <https://support.rstudio.com/hc/en-us/articles/200486468>.

Steps taken during process

- Identify Project
- Write Code
- Publish Project

Slide With Code
========================================================
Use preloaded "quakes"" Data to look at quake magnitude

```r
str(quakes)
```

```
'data.frame':	1000 obs. of  5 variables:
 $ lat     : num  -20.4 -20.6 -26 -18 -20.4 ...
 $ long    : num  182 181 184 182 182 ...
 $ depth   : int  562 650 42 626 649 195 82 194 211 622 ...
 $ mag     : num  4.8 4.2 5.4 4.1 4 4 4.8 4.4 4.7 4.3 ...
 $ stations: int  41 15 43 19 11 12 43 15 35 19 ...
```

Slide With Plot
========================================================
Sample Histogram on Data, interactive Histogram is included in link on next slide
![plot of chunk unnamed-chunk-2](Presentation-figure/unnamed-chunk-2-1.png)

Link to Project
========================================================
This is the link to my course project. This presentation and project is simplistic but gives a viewer an idea of the capabilities or R and the many attachments that can be used with it.

https://robindan.shinyapps.io/Sample/

Thank you
