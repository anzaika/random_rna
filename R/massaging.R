AddCorrectedExpression = function(total) {
  # Adds a column with length corrected expression to the data.frame
  # passed at total var.
  #
  # Args:
  #   total: data.frame with all the data for GALL, WT and UPF
  # Returns:
  #   The data.frame object passed as "total" parameter with an extra column
  #   "expression_corrected_len".

  gall = subset(total, rep == 'GALL')
  wt   = subset(total, rep == 'WT')
  upf = subset(total, rep == 'UPF')

  gall.resid = resid(lm(gall$expression ~ gall$length))
  wt.resid = resid(lm(wt$expression ~ wt$length))
  upf.resid = resid(lm(upf$expression ~ upf$length))

  gall$expression_corrected_len = gall.resid
  wt$expression_corrected_len = wt.resid
  upf$expression_corrected_len = upf.resid

  total = rbind(gall,wt,upf)
  return(total)
}

FilterByLength = function(total, min = 100, max = 250) {
  # Leave only inserts with length in the specific interval
  #
  # Args:
  #   total: data.frame object
  #   min: lower boundary for length
  #   max: higher boundary for length
  # Returns:
  #   The data.frame object.
  total = subset(total, insert_l >= min & insert_l <= max)
  return(total)
}

FilterByDNAReadCount = function(total, count = 100) {
  # Leave only inserts with specific amount of DNA read counts
  #
  # Args:
  #   total: data.frame object
  #   count: minimum number of DNA read counts
  # Returns:
  #   The data.frame object.
  total = subset(total, dna > count)
  return(total)
}
