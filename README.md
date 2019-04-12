
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

You can check if all the packages within `natverse` are uptodate with:

1.For dependencies installed via CRAN use

``` r
natverse_update(source = 'CRAN')
#> 
#> The following natverse dependencies from CRAN are out-of-date, see details below:
#> 
#> package    cran      local     status 
#> ---------  --------  --------  -------
#> cli        1.1.0     1.1.0     ✔      
#> crayon     1.3.4     1.3.4     ✔      
#> dplyr      0.8.0.1   0.8.0.1   ✔      
#> knitr      1.22      1.22      ✔      
#> magrittr   1.5       1.5       ✔      
#> pbapply    1.4.0     1.3.4     ✖      
#> purrr      0.3.2     0.3.2     ✔      
#> stringr    1.4.0     1.4.0     ✔      
#> tibble     2.1.1     2.1.1     ✔      
#> 
#> Start a clean R session then run:
#> install.packages("pbapply")
```

2.For dependencies installed via GitHub use

``` r
natverse_update(source = 'GITHUB')
#> 
#> The following natverse dependencies from GITHUB are out-of-date, see details below:
#> 
#> package              github       local        source                                            status 
#> -------------------  -----------  -----------  ------------------------------------------------  -------
#> catmaid              0.9.7        0.9.6        Github (jefferis/rcatmaid@ead7f48)                ✖      
#> catnat               0.1          0.1          Github (jefferislab/catnat@da299c7)               ✔      
#> drvid                0.3.0        0.3.0        Github (jefferis/drvid@44cbf3e)                   ✔      
#> dtupdate             1.5          1.5          Github (hrbrmstr/dtupdate@58056ea)                ✔      
#> elmr                 0.5.5.9000   0.5.5.9000   Github (jefferis/elmr@e34dc5e)                    ✔      
#> fafbseg              0.6.1        0.6.0        Github (jefferis/fafbseg@8b0c291)                 ✖      
#> nat                  1.9.0        1.9.0        Github (jefferis/nat@f4af0b1)                     ✔      
#> nat.flybrains        1.7.2        1.7.2        Github (jefferislab/nat.flybrains@3e4c535)        ✔      
#> nat.templatebrains   0.9          0.9          Github (jefferislab/nat.templatebrains@d45884e)   ✔      
#> neuprintr            0.2.0        0.2.0        Github (jefferislab/neuprintr@51012fe)            ✔      
#> tidyverse            1.2.1.9000   1.2.1.9000   Github (hadley/tidyverse@5c6f3ef)                 ✔      
#> usethis              1.5.0.9000   1.4.0.9000   Github (r-lib/usethis@2749025)                    ✖      
#> 
#> Start a clean R session then run:
#> devtools::install_github(c("jefferis/rcatmaid", "jefferis/fafbseg", "r-lib/usethis"))
```
