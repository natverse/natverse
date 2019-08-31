
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
#> Loading required package: nat.nblast
#> Loading required package: catmaid
#> Loading required package: httr
```

Conflicts between functions added to the search path by loading the
`natverse` and equivalently named functions in other packages can by
running:

``` r
natverse_conflicts()
#> ── Conflicts ───────────────────────────────────────────────── natverse_conflicts() ──
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
#> remotes::update_packages("natverse")
#> 
#> The following natverse dependencies from CRAN GITHUB are out-of-date, see details below:
#> 
#> package        remote       local        source                                   status      
#> -------------  -----------  -----------  ---------------------------------------  -------     
#> cli            1.1.0        1.1.0        CRAN (R 3.6.0)                           ✔           
#> crayon         1.3.4        1.3.4        CRAN (R 3.6.0)                           ✔           
#> dplyr          0.8.3        0.8.3        CRAN (R 3.6.0)                           ✔           
#> fafbseg        NA           0.6.4        local                                    ❓      
#> magrittr       1.5          1.5          CRAN (R 3.6.0)                           ✔           
#> pbapply        1.4.2        1.4.1        CRAN (R 3.6.0)                           ✖           
#> purrr          0.3.2        0.3.2        CRAN (R 3.6.0)                           ✔           
#> remotes        2.1.0        2.1.0        CRAN (R 3.6.0)                           ✔           
#> sessioninfo    1.1.1        1.1.1        CRAN (R 3.6.0)                           ✔           
#> stringr        1.4.0        1.4.0        CRAN (R 3.6.0)                           ✔           
#> tibble         2.1.3        2.1.3        CRAN (R 3.6.0)                           ✔           
#> drvid          0.3.0        0.3.0        Github (jefferis/drvid@cdd2a48)          ✔           
#> elmr           0.5.6        0.5.6        Github (jefferis/elmr@5bec417)           ✔           
#> nat            1.9.1.9000   1.9.1.9000   Github (jefferis/nat@3ab1eda)            ✔           
#> neuprintr      0.2.0        0.2.0        Github (jefferislab/neuprintr@ec18f21)   ✔           
#> fishatlas      NA           NA           NA                                       ❓      
#> insectbrainr   NA           NA           NA                                       ❓      
#> 
#> Start a clean R session then run:
#> install.packages("pbapply")
```

This also prints instructions for how to update those dependencies.
