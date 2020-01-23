library(RefManageR)
bib=ReadBib('data-raw/natverse.bib')

con=file('inst/CITATION', open = 'w')
writeLines(c(
  'citHeader(
  "If you use the natverse, please cite our paper (Manton, Bates et al 2019).",
  "This is currently available as a bioRxiv preprint but will be submitted for",
  "publication before the end of 2019.",
  "You may need to cite additional publications if you use specific packages",
  "that implement specialised algorithms or provide datasets for reanalysis.",
  "Use a command like:",
  "citation(package=\\\"flycircuit\\\")",
  "to see if there is a specific citation to use for a given package",
  "in addition to the general natverse paper.")'), con = con)
dput(bib, file = con)
close(con)
