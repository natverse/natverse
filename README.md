
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
remotes::install_github("natverse/natverse", dependencies = TRUE)
```

Once installed, you check the status of all natverse packages and their
dependencies like so:

``` r
natverse_update()
```

You can then update like so:

``` r
natverse_update(update = TRUE)
```

However, if you are in a hurry and want to save time from the questions
use like below:

``` r
natverse_update(update=TRUE, upgrade = 'always')
```

If want to upgrade the natverse package itself:

``` r
remotes::update_packages('natverse')
```

## Example

This will load the `natverse` package:

``` r
library(natverse)
#> Loading required package: elmr
#> Loading required package: catmaid
#> Loading required package: httr
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
#> Loading required package: nat.flybrains
#> Loading required package: nat.templatebrains
#> Loading required package: nat.nblast
```

Conflicts between functions added to the search path by loading the
`natverse` and equivalently named functions in other packages can by
running:

``` r
natverse_conflicts()
#> ── Conflicts ───────────────────────────────────────────────────────── natverse_conflicts() ──
#> ✖ nat::intersect() masks base::intersect()
#> ✖ nat::setdiff()   masks base::setdiff()
#> ✖ nat::union()     masks base::union()
```

You can check if all the packages within `natverse` are up to date with:

``` r
natverse_deps()
#> 
#> package: fishatlas was not found
#> 
#> package: insectbrainr was not found
#> 
#> The following packages are either locally installed or information about them is missing!
#> 
#>   catnat, fafbseg, Rvcg
#> 
#> Please install them manually from their appropriate source locations
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
#> package        remote         local   source   repo       status      
#> -------------  -------------  ------  -------  ---------  -------     
#> fishatlas      b7e85e4e1...   NA      GitHub   natverse   ❓      
#> insectbrainr   e80f497aa...   NA      GitHub   natverse   ❓
```
