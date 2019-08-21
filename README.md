
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
#> ── Conflicts ────────────────────────────────────────────────────────────────────────── natverse_conflicts() ──
#> ✖ nat::intersect() masks base::intersect()
#> ✖ nat::setdiff()   masks base::setdiff()
#> ✖ nat::union()     masks base::union()
```

You can check if all the packages within `natverse` are up to date with:

1.For dependencies installed via CRAN use

``` r
natverse_update(source = 'CRAN')
#> 
#> All natverse dependencies from CRAN are up-to-date, see details below:
#> 
#> package    cran    local   status 
#> ---------  ------  ------  -------
#> cli        1.1.0   1.1.0   ✔      
#> crayon     1.3.4   1.3.4   ✔      
#> dplyr      0.8.3   0.8.3   ✔      
#> magrittr   1.5     1.5     ✔      
#> pbapply    1.4.1   1.4.1   ✔      
#> purrr      0.3.2   0.3.2   ✔      
#> stringr    1.4.0   1.4.0   ✔      
#> tibble     2.1.3   2.1.3   ✔
```

2.For dependencies installed via GitHub use

``` r
natverse_update(source = 'GITHUB')
#> 
#> The following natverse dependencies from GITHUB are out-of-date, see details below:
#> 
#> package              github       local        source                                               status      
#> -------------------  -----------  -----------  ---------------------------------------------------  -------     
#> catmaid              0.9.9.9000   0.9.9        Github (jefferis/rcatmaid@239aa68)                   ✖           
#> catnat               0.1          0.1          Github (jefferislab/catnat@7203c2a)                  ✔           
#> DependenciesGraphs   0.3          0.3          Github (datastorm-open/DependenciesGraphs@3c33e2a)   ✔           
#> drvid                0.3.0        0.3.0        Github (jefferis/drvid@cdd2a48)                      ✔           
#> elmr                 0.5.6        0.5.6        Github (jefferis/elmr@5bec417)                       ✔           
#> frulhns              0.5.0        0.5.0        Github (jefferis/frulhns@d8d650a)                    ✔           
#> gphys                0.12         0.12         Github (jefferis/gphys@884da72)                      ✔           
#> nat                  1.9.1.9000   1.9.1.9000   Github (jefferis/nat@3e7652d)                        ✔           
#> nat.ants             0.0.0.9000   0.0.0.9000   Github (jefferis/nat.ants@1ff3154)                   ✔           
#> nat.flybrains        1.7.3        1.7.3        Github (jefferislab/nat.flybrains@f293ff0)           ✔           
#> nat.jrcfibf          NA           0.1.0        Github (flyconnectome/nat.jrcfibf@0aeebbc)           ❓      
#> neuprintr            0.2.0        0.2.0        Github (jefferislab/neuprintr@ec18f21)               ✔           
#> paperutils           0.3          0.3          Github (jefferis/paperutils@970a5f1)                 ✔           
#> physplit.analysis    0.3.2        0.3.2        Github (jefferislab/physplit.analysis@498edbc)       ✔           
#> physplitdata         1.2          1.2          Github (jefferislab/physplitdata@ad9a3dd)            ✔           
#> RNeo4j               1.7.0        1.7.0        Github (nicolewhite/RNeo4j@eea1ac1)                  ✔           
#> tracerutils          0.8.1        0.8.1        Github (flyconnectome/tracerutils@8dc49b9)           ✔           
#> vfbr                 0.3.3        0.3.3        Github (jefferis/vfbr@40dac62)                       ✔           
#> 
#> Start a clean R session then run:
#> devtools::install_github("jefferis/rcatmaid")
```
