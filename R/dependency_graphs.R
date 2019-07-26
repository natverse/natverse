
list_natpackages <- function(){
  c('nat','elmr','fafbseg','nat.h5reg','nat.jrcfibf',
    'natverse','nat.jrcbrains','catnat','nat.ants',
    'nat.templatebrains','nat.nblast','nat.flybrains',
    'nat.utils', 'catmaid','neuprintr','drvid','fafbsegdata',
    'flycircuit')
}

list_corenatsupportpackages <- function(){
  c('igraph', 'Morpho', 'Rvcg', 'alphashape3d', 'rgl', 'nabor')
}


#' List all dependencies between natverse packages Adapted from the function
#' \code{Pck.load.to.vis} in 'DependenciesGraphs'
#' @param Packages : Names of packages to includes to extract
#' @param level : Level of the dependencies to extract (if level is set to
#'   level_2 then further nat dependencies will be depicted)
#' @param color_list : Name of color to use
#' @return List to graph
#' @examples
#' if (!require(DependenciesGraphs)) utils::install.packages("DependenciesGraphs")
#' if (!require(visNetwork)) utils::install.packages("visNetwork")
#' dep <- dependency_visualization('natverse', level = 'level_1')
#'
#' @export
dependency_visualization <- function(Packages = "All", level = c('level_1','level_2'),
                                     color_list = c("red", "blue", "green")) {
  link <- DependenciesGraphs::Pck.load()
  level <- match.arg(level)

  if (Packages[1] == "All") {
    packages.view <- utils::installed.packages()[, 1]
  } else {
    packages.view <- c(Packages, as.character(link[which(link[, 1] %in% Packages), 2]),
                       as.character(link[which(link[, 2] %in% Packages), 1]))
    if (level == 'level_2') {
        nat_packages <- list_natpackages()
        tempval <- unique(nat_packages,unique(packages.view))
        level2_packages <- c(tempval, as.character(link[which(link[, 1] %in% tempval), 2]),
                        as.character(link[which(link[, 2] %in% tempval), 1]))
        level2_packages <- intersect(level2_packages,union(list_corenatsupportpackages(),nat_packages))
        packages.view <- c(level2_packages,packages.view)
        #packages.view <- setdiff(packages.view,'natverse')
    }

  }

  visdata <- DependenciesGraphs::prepareToVis(link, unique(packages.view))

  names(visdata$fromto)[3] <- "title"
  visdata$fromto$title <- paste0("<p>", visdata$fromto$title, "</p>")
  visdata$fromto$color <- as.numeric(as.factor(visdata$fromto$title))

  for (i in 1:length(unique(visdata$fromto$color))) {
    visdata$fromto$color[which(as.character(visdata$fromto$color) == as.character(i))] <- color_list[i]
  }

  class(visdata) <- "dependenciesGraphs"
  return(visdata)
}


#' Plot network for dependenciesGraphs object
#'
#' Plot network for dependenciesGraphs object. Using visNetwork package. Adapted from the method
#' \code{plot} in 'DependenciesGraphs'
#'
#' @param object : dependenciesGraphs object.
#' @param block : Boolean. Default to False. When false, the nodes that are not fixed can be dragged by the user.
#' @param width	: Width (optional, defaults to automatic sizing)
#' @param height : Height (optional, defaults to automatic sizing)
#'
#' @examples
#' if (!require(DependenciesGraphs)) install.packages("DependenciesGraphs")
#' if (!require(visNetwork)) install.packages("visNetwork")
#' dep <- dependency_visualization('natverse', level = 'level_1')
#' dependency_plot(dep)
#'
#' # size
#' dependency_plot(dep, height = "800px", width = "100%")
#'
#' @export
dependency_plot <- function(object, block = FALSE, width = NULL, height = NULL) {
  nodes <- data.frame(object[[1]])
  edges <- data.frame(object[[2]])
  # nodes$color.background <- "slategrey"
  nodes$color.border <- "black"
  nodes$color.highlight.background <- "orange"
  nodes$color.highlight.border <- "darkred"
  nodes$font.size = 30

  nodes$group <- 'external'

  nat_packages <- list_natpackages()
  nodes$group[which(nodes$label %in% nat_packages)] <- 'nat_pack'
  nodes$group[which(nodes$label %in% 'nat')] <- 'nat'

  nodes$shape <- "circle"
  edges$smooth <- TRUE
  edges$shadow <- TRUE # edge shadow
  edges$arrows <- "from"

  colorlist <- list()
  colorlist[[ "Depends" ]] <- "red"
  colorlist[[ "Imports" ]] <- "blue"
  colorlist[[ "Suggests" ]] <- "green"
  colorlist[[ "LinkingTo" ]] <- "magenta"

  names(colorlist) <- paste0('<p>',names(colorlist), '</p>')

  names(colorlist) %in% unique(edges$title)

  usecolorlist <- c(unlist(colorlist[names(colorlist) %in% unique(edges$title)]))
  tempval <- c(unlist(names(colorlist[names(colorlist) %in% unique(edges$title)])))
  uselabellist <- gsub('<(/)*p>', x= tempval, replacement = '')

  ledges <- data.frame(color = usecolorlist,label = uselabellist)

  lnodes <- data.frame(label = c('external', 'nat_pack'),color = c("slategrey", "lightblue"))
  nodes$title <- 'NA'
  for (i in 1:nrow(nodes)){
    pckg_descpription <- gsub('\n\\s+', ' ', utils::packageDescription(pkg = nodes$label[i],
                                                                       fields = 'Description'))
    if (is.na(pckg_descpription)){pckg_descpription <- 'No Description'}
    pckg_descpription <- paste0(nodes$label[i],": ",pckg_descpription)
    pckg_descpription <- gsub('\n', ' ', pckg_descpription)
    pckg_descpription <- gsub('(.{1,70})(\\s|$)', '\\1\n', pckg_descpription)
    pckg_descpription <- gsub('\n', '<br />', pckg_descpription)
    nodes$title[i] <- paste0("<p>", pckg_descpription,"</p>")
  }

  #nodes$value = 30
  nodes$label <- lapply(nodes$label, as.character)
  nodes$label <- ifelse(nchar(nodes$label) < 7, paste("    ", nodes$label,"    ", sep=""), nodes$label)


  visNetwork::visNetwork(nodes, edges, width = width, height = height) %>%
    visNetwork::visEdges(arrows = "middle") %>%
    visNetwork::visGroups(groupname = "nat_pack", color = "lightblue") %>%
    visNetwork::visGroups(groupname = "external", color = "slategrey")  %>%
    visNetwork::visGroups(groupname = "nat", color = "yellow")  %>%
    visNetwork::visLegend(addEdges = ledges, addNodes = lnodes, useGroups = FALSE,width = 0.1) %>%
    visNetwork::visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
    visNetwork::visInteraction(dragNodes = !block) %>%
    visNetwork::visPhysics(solver = "repulsion", repulsion = list(nodeDistance  = 200,
                                                                  springLength = 150,springConstant = 0.009 ),
               stabilization = list(enabled = FALSE, iterations = 500, onlyDynamicEdges = FALSE))

}
