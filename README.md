
<!-- README.md is generated from README.Rmd. Please edit that file -->

# natverse <a href='https://natverse.github.io/'><img src='man/figures/logo.svg' align="right" height="138.5" /></a>

<!-- badges: start -->

[![natverse](https://img.shields.io/badge/natverse-Part%20of%20the%20natverse-a241b6)](https://natverse.github.io)
[![Docs](https://img.shields.io/badge/docs-100%25-brightgreen.svg)](https://natverse.github.io/natverse/reference/)
[![Travis build
status](https://travis-ci.org/natverse/natverse.svg?branch=master)](https://travis-ci.org/natverse/natverse)
<!-- badges: end -->

The goal of natverse is to install all of the commonly used NeuroAnatomy
Toolbox packages.

See <https://natverse.github.io> for more details.

## Installation

You can install the latest version as shown below:

``` r
if(!requireNamespace('remotes')) install.packages('remotes')
remotes::install_github("natverse/natverse")
```

Once installed, you can update natverse and all its dependencies like
so:

``` r
remotes::update_packages('natverse')
```

This will ask you to confirm whether you want to update dependencies
(and their dependencies).

If want to upgrade all dependencies without answering any questions:

``` r
remotes::update_packages('natverse', upgrade='always')
```

## Example

This will load the `natverse` package:

``` r
library(natverse)
#> Loading required package: elmr
#> Loading required package: nat.flybrains
#> Loading required package: nat.templatebrains
#> Loading required package: rgl
#> Loading required package: nat
#> Registered S3 method overwritten by 'nat':
#>   method             from
#>   as.mesh3d.ashape3d rgl
#> 
#> Attaching package: 'nat'
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, union
#> Loading required package: nat.nblast
#> Loading required package: catmaid
#> Loading required package: httr
```

Conflicts between functions added to the search path by loading the
`natverse` and equivalently named functions in other packages can by
running:

``` r
natverse_conflicts()
#> ── Conflicts ────────────────────────────────────────────────────────────── natverse_conflicts() ──
#> ✖ nat::intersect() masks base::intersect()
#> ✖ nat::setdiff()   masks base::setdiff()
#> ✖ nat::union()     masks base::union()
```

You can check if all the packages within `natverse` are up to date with:

``` r
natverse_update()
#> 
#> The following natverse dependencies are missing!
#> 
#>   fishatlas, insectbrainr
#> 
#> We recommend installing them by running:
#> natverse_update(update=TRUE)
#> 
#> The following natverse dependencies are out-of-date, see details below:
#> 
#> We recommend updating them by running:
#> natverse_update(update=TRUE)
#> 
#> package              remote         local          source   status      
#> -------------------  -------------  -------------  -------  -------     
#> DependenciesGraphs   3c33e2a1c...   3c33e2a1c...   GitHub   ✔           
#> drvid                cdd2a48c7...   cdd2a48c7...   GitHub   ✔           
#> elmr                 e6da79673...   e34dc5e4d...   GitHub   ✖           
#> fafbseg              479dd1340...   1a8bcea96...   GitHub   ✖           
#> nat                  a74a03719...   1.9.1.9000     GitHub   ✖           
#> neuprintr            fb25dcb9c...   f3e640d19...   GitHub   ✖           
#> fishatlas            b7e85e4e1...   NA             GitHub   ❓      
#> insectbrainr         1a967c964...   NA             GitHub   ❓      
#> cli                  1.1.0          1.1.0          CRAN     ✔           
#> crayon               1.3.4          1.3.4          CRAN     ✔           
#> dplyr                0.8.3          0.8.3          CRAN     ✔           
#> magrittr             1.5            1.5            CRAN     ✔           
#> pbapply              1.4-2          1.4-2          CRAN     ✔           
#> purrr                0.3.2          0.3.2          CRAN     ✔           
#> sessioninfo          1.1.1          1.1.1          CRAN     ✔           
#> stringr              1.4.0          1.4.0          CRAN     ✔           
#> tibble               2.1.3          2.1.3          CRAN     ✔           
#> remotes              2.1.0          2.1.0          CRAN     ✔           
#> ggplot2              3.2.1          3.2.1          CRAN     ✔           
#> here                 0.1            0.1            CRAN     ✔           
#> knitr                1.25           1.25           CRAN     ✔           
#> png                  0.1-7          0.1-7          CRAN     ✔           
#> spelling             2.1            2.1            CRAN     ✔           
#> testthat             6b707165d...   4a546faf6...   GitHub   ✖           
#> visNetwork           2.0.8          2.0.8          CRAN     ✔           
#> rgl                  0.100.30       0.100.30       CRAN     ✔           
#> nabor                0.5.0          0.5.0          CRAN     ✔           
#> igraph               1.2.4.1        1.2.4.1        CRAN     ✔           
#> filehash             2.4-2          2.4-2          CRAN     ✔           
#> digest               0.6.21         0.6.21         CRAN     ✔           
#> nat.utils            0.5.1          0.5.1          CRAN     ✔           
#> plyr                 1.8.4          1.8.4          CRAN     ✔           
#> yaml                 2.2.0          2.2.0          CRAN     ✔           
#> assertthat           0.2.1          0.2.1          CRAN     ✔           
#> glue                 1.3.1          1.3.1          CRAN     ✔           
#> pkgconfig            2.0.3          2.0.3          CRAN     ✔           
#> R6                   2.4.0          2.4.0          CRAN     ✔           
#> Rcpp                 1.0.2          1.0.2          CRAN     ✔           
#> rlang                0.4.0          0.4.0          CRAN     ✔           
#> tidyselect           0.2.5          0.2.5          CRAN     ✔           
#> BH                   1.69.0-1       1.69.0-1       CRAN     ✔           
#> plogr                0.2.0          0.2.0          CRAN     ✔           
#> withr                2.1.2          2.1.2          CRAN     ✔           
#> stringi              1.4.3          1.4.3          CRAN     ✔           
#> fansi                0.4.0          0.4.0          CRAN     ✔           
#> pillar               1.4.2          1.4.2          CRAN     ✔           
#> gtable               0.3.0          0.3.0          CRAN     ✔           
#> lazyeval             0.2.2          0.2.2          CRAN     ✔           
#> reshape2             1.4.3          1.4.3          CRAN     ✔           
#> scales               1.0.0          1.0.0          CRAN     ✔           
#> viridisLite          0.3.0          0.3.0          CRAN     ✔           
#> rprojroot            1.3-2          1.3-2          CRAN     ✔           
#> evaluate             0.14           0.14           CRAN     ✔           
#> highr                0.8            0.8            CRAN     ✔           
#> markdown             1.1            1.1            CRAN     ✔           
#> xfun                 dbe34e41d...   1385b1673...   GitHub   ✖           
#> commonmark           1.7            1.7            CRAN     ✔           
#> xml2                 1.2.2          1.2.2          CRAN     ✔           
#> hunspell             3.0            3.0            CRAN     ✔           
#> praise               1.0.0          1.0.0          CRAN     ✔           
#> htmlwidgets          1.5.1          1.5.1          CRAN     ✔           
#> htmltools            0.4.0          0.4.0          CRAN     ✔           
#> jsonlite             1.6            1.6            CRAN     ✔           
#> shiny                1.4.0          1.4.0          CRAN     ✔           
#> crosstalk            1.0.0          1.0.0          CRAN     ✔           
#> manipulateWidget     0.10.0         0.10.0         CRAN     ✔           
#> miniUI               0.1.1.1        0.1.1.1        CRAN     ✔           
#> base64enc            0.1-3          0.1-3          CRAN     ✔           
#> webshot              0.5.1          0.5.1          CRAN     ✔           
#> httpuv               1.5.2          1.5.2          CRAN     ✔           
#> mime                 0.7            0.7            CRAN     ✔           
#> xtable               1.8-4          1.8-4          CRAN     ✔           
#> sourcetools          0.1.7          0.1.7          CRAN     ✔           
#> later                1.0.0          1.0.0          CRAN     ✔           
#> promises             1.1.0          1.1.0          CRAN     ✔           
#> fastmap              1.0.1          1.0.1          CRAN     ✔           
#> callr                3.3.2          3.3.2          CRAN     ✔           
#> processx             3.4.1          3.4.1          CRAN     ✔           
#> labeling             0.3            0.3            CRAN     ✔           
#> munsell              0.5.0          0.5.0          CRAN     ✔           
#> RColorBrewer         1.1-2          1.1-2          CRAN     ✔           
#> colorspace           1.4-1          1.4-1          CRAN     ✔           
#> utf8                 1.1.4          1.1.4          CRAN     ✔           
#> vctrs                0.2.0          0.2.0          CRAN     ✔           
#> ps                   1.3.0          1.3.0          CRAN     ✔           
#> backports            1.1.5          1.1.5          CRAN     ✔           
#> ellipsis             0.3.0          0.3.0          CRAN     ✔           
#> zeallot              0.1.0          0.1.0          CRAN     ✔           
#> RcppEigen            0.3.3.5.0      0.3.3.5.0      CRAN     ✔
```
