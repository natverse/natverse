#' Generate Logo for the natverse package
#'
#' This will generate logo for natverse package based on the png image created by Alex Bates
#' Further produce a hex sticker based on the package \code{hexSticker}
#' Adapted and modified from the following sources : \url{https://github.com/Bioconductor/BiocStickers}
#' @export
#' @examples
#' \dontrun{
#' library(hexSticker)
#' library(ggplot2)
#' library(here)
#' natlogo_generation()
#' }
#'
natlogo_generation <- function(){

  natverse_png <- png::readPNG(file.path(here::here("presentation"),"natverse_raw.png"))
  natverse_png <- grid::rasterGrob(natverse_png, width = 1, x = 0.5, y = 0.61,
                             interpolate = TRUE)

  plot_object <- ggplot2::ggplot() +
    ggplot2::annotation_custom(natverse_png) +
    ggplot2::theme_void()

  ## Create image now..
  set.seed(123)
  col_border <- "lightblue"
  col_bg <- "white"
  hexSticker::sticker(plot_object, package="Natverse",
          s_x = 1, s_y = 0.75, s_width = 1.6, s_height = 2.2,
          h_fill = col_bg, h_color = col_border,
          filename=file.path(here::here("presentation"),"natverse_logo.png"),
          spotlight = TRUE,
          l_x = 1.0, l_y = 0.45, l_alpha = 0.3,
          p_size = 5, p_x = 1.05, p_y = 0.5,
          p_color = 'grey', p_family = "Aller_Lt")

}
