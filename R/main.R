source("R/helpers.R")
source("R/massaging.R")
source("R/plots.R")

Data = function() {
  # Load data for all three experiments into a single data.frame
  # Returns:
  #   The data.frame object.

  gall = read.table("outputs/gall.tsv", sep="\t", header=T)
  wt = read.table("outputs/wt.tsv", sep="\t", header=T)
  upf = read.table("outputs/upf.tsv", sep="\t", header=T)

  total = rbind(gall,wt,upf)
  return(total)
}
