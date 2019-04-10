
<!-- README.md is generated from README.Rmd. Please edit that file -->
natverse
========

<!-- badges: start -->
<!-- badges: end -->
The goal of natverse is to install all of the commonly used NeuroAnatomy Toolbox packages.

See <https://jefferis.github.io/nat/> for more details.

Installation
------------

You can install the latest version as shown below:

``` r
# install.packages("devtools")
devtools::install_github("SridharJagannathan/natverse")
```

Example
-------

This will load the `natverse` package:

``` r
library(natverse)
#> Loading required package: nat
#> Loading required package: rgl
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
#> ── Conflicts ───────────────────────────────────────────────────────────────────────────────────────────────── natverse_conflicts() ──
#> ✖ nat::intersect() masks base::intersect()
#> ✖ nat::setdiff()   masks base::setdiff()
#> ✖ nat::union()     masks base::union()
```
