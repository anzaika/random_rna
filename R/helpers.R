library(ggplot2)
library(plyr)
library(grid)
library(gridExtra)

# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)

  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }

  if (numPlots==1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

CorrelationBetweenLengthAndExpressionByRep = function(total) {
  return(data.frame(COR = cor(total$expression_corrected_len, total$length)))
}

SavePlot = function(plot) {
  filename = paste("figs/", deparse(sys.calls()[[sys.nframe()-1]]), ".jpg")
  filename = sub("\\(\\) ", "", filename)
  ggsave(file=filename, plot=plot)
}

DrawPlotWithFootnote = function(plot, wide = F) {
  filename = paste("figs/", deparse(sys.calls()[[sys.nframe()-1]]), ".jpg")
  filename = sub("\\(\\) ", "", filename)

  if (wide) { widt = 15 } else { widt = 10 }
  # jpeg(filename = filename, width = widt, height = 10, units = "in", res = 400, quality = 75)
  jpeg(filename = filename, width = 45, height = 25, units = "in", res = 180, quality = 70)

  label = paste("Created with function: ",
                deparse(sys.calls()[[sys.nframe()-1]]),
                " on ",
                format(Sys.time(), "%d %b %Y"))

  footnote = textGrob(label, gp = gpar(fontsize = 12, col = "gray"))

  # layout
  vp.layout <- grid.layout(
                 nrow = 2,
                 ncol = 1,
                 heights = unit(c(14, 1), "null"))

  # init
  grid.newpage()
  pushViewport(viewport(layout=vp.layout, name="layout"))

  # plot
  pushViewport(viewport(layout.pos.row=1, layout.pos.col=1, name="plot"))
  print(plot, newpage=FALSE)
  upViewport()

  # footnote
  pushViewport(viewport(layout.pos.row=2, layout.pos.col=1, name="table"))
  grid.draw(footnote)
  upViewport()
  dev.off()
}
