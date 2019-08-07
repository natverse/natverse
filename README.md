
<!-- README.md is generated from README.Rmd. Please edit that file -->

# natverse <a href='https://natverse.github.io/'><img src='images/hex-natverse_logo.png' align="right" height="138.5" /></a>

<!-- badges: start -->

[![Github All Releases](https://img.shields.io/github/downloads/natverse/natverse/total.svg)]()

<!-- badges: end -->

The goal of natverse is to install all of the commonly used NeuroAnatomy
Toolbox packages.

See <https://jefferis.github.io/nat/> for more details.

## Installation

You can install the latest version as shown below:

``` r
# install.packages("devtools")
devtools::install_github("SridharJagannathan/natverse")
```

## Example

This will load the `natverse` package:

``` r
library(natverse)
#> Loading required package: nat
#> Loading required package: rgl
#> Registered S3 method overwritten by 'nat':
#>   method             from
#>   as.mesh3d.ashape3d rgl
#> 
#> Attaching package: 'nat'
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, union
#> Loading required package: elmr
#> Loading required package: nat.flybrains
#> Loading required package: nat.templatebrains
#> Loading required package: nat.nblast
#> Loading required package: catmaid
#> Loading required package: httr
```

The conflicts created by `natverse` with other packages can be seen with

``` r
natverse_conflicts()
#> ── Conflicts ──────────────────────────────────────────────────────────────────────── natverse_conflicts() ──
#> ✖ nat::intersect() masks base::intersect()
#> ✖ nat::setdiff()   masks base::setdiff()
#> ✖ nat::union()     masks base::union()
```

You can check if all the packages within `natverse` are uptodate with:

1.For dependencies installed via CRAN use

``` r
natverse_update(source = 'CRAN')
#> 
#> The following natverse dependencies from CRAN are out-of-date, see details below:
#> 
#> package      cran    local   status 
#> -----------  ------  ------  -------
#> cli          1.1.0   1.1.0   ✔      
#> crayon       1.3.4   1.3.4   ✔      
#> dplyr        0.8.3   0.8.1   ✖      
#> knitr        1.23    1.23    ✔      
#> magrittr     1.5     1.5     ✔      
#> pbapply      1.4.1   1.4.1   ✔      
#> purrr        0.3.2   0.3.2   ✔      
#> stringr      1.4.0   1.4.0   ✔      
#> tibble       2.1.3   2.1.3   ✔      
#> visNetwork   2.0.7   2.0.7   ✔      
#> 
#> Start a clean R session then run:
#> install.packages("dplyr")
```

2.For dependencies installed via GitHub use

``` r
natverse_update(source = 'GITHUB')
#> 
#> The following natverse dependencies from GITHUB are out-of-date, see details below:
#> 
#> package              github       local        source                                              status 
#> -------------------  -----------  -----------  --------------------------------------------------  -------
#> ANTsR                0.4.9        0.4.9        Github (stnava/ANTsR@69d65b6)                       ✔      
#> ANTsRCore            0.7.0        0.6.5        Github (ANTsX/ANTsRCore@75c61a6)                    ✖      
#> catmaid              0.9.9        0.9.9        Github (jefferis/rcatmaid@6cbc83a)                  ✔      
#> catnat               0.1          0.1          Github (jefferislab/catnat@12456e8)                 ✔      
#> cmaker               3.11.4.0     3.11.4.0     Github (stnava/cmaker@c89fe8e)                      ✔      
#> cranly               0.5.2        0.5.2        Github (ikosmidis/cranly@b34d49f)                   ✔      
#> DependenciesGraphs   0.3          0.3          Github (DataKnowledge/DependenciesGraphs@3c33e2a)   ✔      
#> drvid                0.3.0        0.3.0        Github (jefferis/drvid@cdd2a48)                     ✔      
#> elmr                 0.5.6        0.5.5.9000   Github (jefferis/elmr@e34dc5e)                      ✖      
#> fafbseg              0.6.4        0.6.3        Github (jefferis/fafbseg@1a8bcea)                   ✖      
#> hexSticker           0.4.6        0.4.6        Github (GuangchuangYu/hexSticker@f276d6d)           ✔      
#> ITKR                 0.5.0        0.5.0        Github (stnava/ITKR@1b88aa6)                        ✔      
#> nat                  1.9.1        1.9.0        Github (jefferis/nat@0dd3be6)                       ✖      
#> nat.ants             0.0.0.9000   0.0.0.9000   Github (jefferis/nat.ants@1ff3154)                  ✔      
#> nat.flybrains        1.7.3        1.7.2        Github (jefferislab/nat.flybrains@3e4c535)          ✖      
#> nat.h5reg            0.3.1        0.3.0.9000   Github (jefferis/nat.h5reg@346d7fc)                 ✖      
#> neuprintr            0.2.0        0.2.0        Github (jefferislab/neuprintr@f3e640d)              ✔      
#> rfigshare            0.3.7.100    0.3.7.100    Github (ropensci/rfigshare@3379786)                 ✔      
#> testthat             2.2.1.9000   2.1.1.9000   Github (r-lib/testthat@4a546fa)                     ✖      
#> xaringan             0.11.1       0.11.1       Github (yihui/xaringan@a302c7d)                     ✔      
#> xfun                 0.8.1        0.8.1        Github (yihui/xfun@1385b16)                         ✔      
#> 
#> Start a clean R session then run:
#> devtools::install_github(c("ANTsX/ANTsRCore", "jefferis/elmr", "jefferis/fafbseg", "jefferis/nat", 
#> "jefferislab/nat.flybrains", "jefferis/nat.h5reg", "r-lib/testthat"
#> ))
```
