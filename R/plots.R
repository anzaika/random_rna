library(gridExtra)

BoxplotExprStopCount = function() {
  # Boxplot of length corrected expression vs. stop codon count

  total = AddCorrectedExpression(Data())
  total = subset(total, stop_count < 11)

  theme_set(theme_gray(base_size = 18))

  breaks = c(-10,-7.5,-5,-4,-3,-2,-1,0,1,2,3,4,5)
  limits = c(-10, 5)
  labels = labs(x = "Stop codon count", y = "Expression")

  ggplot(total, aes(factor(stop_count), expression_corrected_len)) +
    geom_boxplot(aes(fill=factor(rep)), notch = T) +
    scale_y_continuous(breaks = breaks, limits = limits) +
    ggtitle("With expression corrected by length") +
    labels
}

BoxplotExprStopTypeCount = function() {
  # Boxplot of length corrected expression vs. stop codon count

  total = AddCorrectedExpression(Data())

  theme_set(theme_gray(base_size = 18))
  # total = subset(total, stop_count )

  breaks = c(-5,-4,-3,-2,-1,0,1,2,3)
  limits = c(-5, 3)
  labels = labs(x = "Stop types count", y = "Expression")

  ggplot(total, aes(factor(stop_types_count), expression_corrected_len)) +
    geom_boxplot(aes(fill=factor(rep)), notch = T) +
    scale_y_continuous(breaks = breaks, limits = limits) +
    ggtitle("With expression corrected by length") +
    labels
}

TwoBoxplots = function () {
  # Two boxplots. First expression vs stop_codon count.
  # Second - corrected_expression vs stop_codon count.

  total = AddCorrectedExpression(Data())
  total = subset(total, stop_count < 11)

  theme_set(theme_gray(base_size = 18))

  breaks = c(-10,-7.5,-5,-4,-3,-2,-1,0,1,2,3,4,5)
  limits = c(-10, 5)
  labels = labs(x = "Stop codon count", y = "Expression")

  f1 =
    ggplot(total, aes(factor(stop_count), expression_corrected_len)) +
    geom_boxplot(aes(fill=factor(rep)), notch = T) +
    scale_y_continuous(breaks = breaks, limits = limits) +
    ggtitle("With expression corrected by length") +
    labels

  f2 =
    ggplot(total, aes(factor(stop_count), expression)) +
    geom_boxplot(aes(fill=factor(rep)), notch=T) +
    scale_y_continuous(breaks = breaks, limits = limits) +
    ggtitle("With uncorrected expression") +
    labels

  multiplot(f1,f2, cols=2)
}

four_boxplots = function () {
  library(ggplot2)

  total = add_corrected_expr(data())
  total = subset(total, stop_count < 11)

  total_10 = cut_data_by_read_count(total, 10)
  total_50 = cut_data_by_read_count(total, 50)
  total_100 = cut_data_by_read_count(total, 100)
  total_250 = cut_data_by_read_count(total, 250)

  theme_set(theme_gray(base_size = 18))

  breaks = c(-5,-4,-3,-2,-1,0,1,2,3)
  limits = c(-5, 3)
  labels = labs(x = "Stop codon count", y = "Expression")

  f1 = ggplot(total_10, aes(factor(stop_count), expression_corrected_len)) + geom_boxplot(aes(fill=factor(rep)), notch = T) + scale_y_continuous(breaks = breaks, limits = limits) + ggtitle("> 10 dna reads") + labels
  f2 = ggplot(total_50, aes(factor(stop_count), expression_corrected_len)) + geom_boxplot(aes(fill=factor(rep)), notch = T) + scale_y_continuous(breaks = breaks, limits = limits) + ggtitle("> 50 dna reads") + labels
  f3 = ggplot(total_100, aes(factor(stop_count), expression_corrected_len)) + geom_boxplot(aes(fill=factor(rep)), notch = T) + scale_y_continuous(breaks = breaks, limits = limits) + ggtitle("> 100 dna reads") + labels
  f4 = ggplot(total_250, aes(factor(stop_count), expression_corrected_len)) + geom_boxplot(aes(fill=factor(rep)), notch = T) + scale_y_continuous(breaks = breaks, limits = limits) + ggtitle("> 250 dna reads") + labels

  multiplot(f1,f2,f3,f4, cols=2)
}

TwoScatterplots = function() {

  total = AddCorrectedExpression(Data())

  total.stop = subset(total, stop_count > 0 & length < 400)
  total.nostop = subset(total, stop_count == 0 & length < 400)

  total.stop.corr = ddply(total.stop, .(rep), CorrelationBetweenLengthAndExpressionByRep)
  total.nostop.corr = ddply(total.nostop, .(rep), CorrelationBetweenLengthAndExpressionByRep)

  x_breaks = c(-10, -8,-6,-4,-2,0,2,4)
  x_limits = c(-11, 4)

  y_breaks = c(100, 150, 200, 250, 300, 350)
  y_limits = c(30, 400)


  f1 =
   ggplot(total.stop ,aes(x=expression_corrected_len, y=length, color=rep)) +
   geom_point(shape=1) +
   scale_colour_hue(l=50) +
   scale_x_continuous(breaks = x_breaks, limits = x_limits) +
   scale_y_continuous(breaks = y_breaks, limits = y_limits) +
   geom_smooth(method=lm, se=FALSE, fullrange=TRUE) +
   ggtitle("With stops and length < 400") +
   scale_fill_discrete(name = "Biological\nreplica", breaks=c) +
   annotation_custom(tableGrob(total.stop.corr), xmin=-11, xmax=-6, ymin=35, ymax=50)


  f2 =
   ggplot(total.nostop ,aes(x=expression_corrected_len, y=length, color=rep)) +
   geom_point(shape=1) +
   scale_colour_hue(l=50) +
   scale_x_continuous(breaks = x_breaks, limits = x_limits) +
   scale_y_continuous(breaks = y_breaks, limits = y_limits) +
   geom_smooth(method=lm, se=FALSE, fullrange=TRUE) +
   ggtitle("Without stops and length < 400") +
   annotation_custom(tableGrob(total.nostop.corr), xmin=-11, xmax=-7, ymin=35, ymax=50)

  multiplot(f1,f2, cols=2)
}

ExpressionVsAvgStopDistanceOnlyTwoStops = function () {
  total = AddCorrectedExpression(Data())
  total = subset(total, length < 300 & stop_count == 2)
  labels = labs(x = "Average distance between stop codons",
                y = "Expression corrected by length (on the base of all inserts)")

  ggplot(total ,aes(x=avg_dist_btwn_all_stops, y=expression_corrected_len, color=rep)) +
  geom_point(shape=1) +
  scale_colour_hue(l=60) +
  geom_smooth(method=lm, fullrange=TRUE) +
  labels +
  ggtitle("Only inserts with 2 stops and length < 400")
}

ExpressionVsAvgStopDistance = function () {
  total = AddCorrectedExpression(Data())
  total = subset(total, length < 300 & stop_count > 1)
  labels = labs(x = "Average distance between all stop codons",
                y = "Expression corrected by length")

  ggplot(total ,aes(x=avg_dist_btwn_all_stops, y=expression_corrected_len, color=rep)) +
  geom_point(shape=1) +
  scale_colour_hue(l=60) +
  geom_smooth() +
  labels
  # ggtitle("With stops and length < 400") +
  # scale_fill_discrete(name = "Biological\nreplica", breaks=c) +
  # annotation_custom(tableGrob(total.stop.corr), xmin=-11, xmax=-6, ymin=35, ymax=50)
}

ExpressionVsAvgStopDistanceBtwFirstThreeStops = function () {
  total = AddCorrectedExpression(Data())
  total = subset(total, length < 300 & stop_count > 1)
  labels = labs(x = "Average distance between first 3 stop codons",
                y = "Expression corrected by length")

  ggplot(total ,aes(x=avg_dist_btwn_first_3_stops, y=expression_corrected_len, color=rep)) +
  geom_point(shape=1) +
  scale_colour_hue(l=60) +
  geom_smooth() +
  labels
  # ggtitle("With stops and length < 400") +
  # scale_fill_discrete(name = "Biological\nreplica", breaks=c) +
  # annotation_custom(tableGrob(total.stop.corr), xmin=-11, xmax=-6, ymin=35, ymax=50)
}


####################################
####### Stop codon density plots ###
####################################


density_corr_to_expr_per_count = function() {
  total = add_corrected_expr(data())
  total = subset(total, stop_density > 0)

  gall = subset(total, rep == 'GALL' & stop_count < 10)
  wt   = subset(total, rep == 'WT' & stop_count < 10)
  upf = subset(total, rep == 'UPF' & stop_count < 10)

  theme_set(theme_gray(base_size = 18))

  breaks = c(-10,-5,0,5,10,15)
  limits = c(-10, 15)
  labels = labs(x = "Stop density", y = "Expression corrected by length")

  f1 = ggplot(gall ,aes(x=stop_density, y=expression_corrected_len, color=as.factor(stop_count))) + geom_point(shape=1) + scale_y_continuous(breaks = breaks, limits = limits) + scale_colour_hue(l=50) + geom_smooth(method=lm, se=FALSE, fullrange=TRUE) + ggtitle("GALL") + labels + scale_colour_discrete(name = 'Stop count')
  f2 = ggplot(wt ,aes(x=stop_density, y=expression_corrected_len, color=as.factor(stop_count))) + geom_point(shape=1) + scale_y_continuous(breaks = breaks, limits = limits) + scale_colour_hue(l=50) + geom_smooth(method=lm, se=FALSE, fullrange=TRUE) + ggtitle("WT") + labels + scale_colour_discrete(name = 'Stop count')
  f3 = ggplot(upf ,aes(x=stop_density, y=expression_corrected_len, color=as.factor(stop_count))) + geom_point(shape=1) + scale_y_continuous(breaks = breaks, limits = limits) + scale_colour_hue(l=50) + geom_smooth(method=lm, se=FALSE, fullrange=TRUE) + ggtitle("UPF") + labels + scale_colour_discrete(name = 'Stop count')

  multiplot(f1,f2,f3, cols=2)

}
