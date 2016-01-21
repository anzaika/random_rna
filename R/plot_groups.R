CompareExpressionVsAvgStopDistance = function () {
  p1 = ExpressionVsAvgStopDistance(upp_len = 300)
  p2 = ExpressionVsAvgStopDistance(upp_len = 1000)
  p3 = ExpressionVsAvgStopDistance(upp_len = 300, stops_count = 2, stops_count_eql = T)
  p4 = ExpressionVsAvgStopDistance(upp_len = 1000, stops_count = 2, stops_count_eql = T)
  p = multiplot(p1,p2,p3,p4, cols = 2)

  DrawPlotWithFootnote(p, wide=T)
}

CompareDifferentMethodsToCountAvgDistanceBtwnStops = function () {
  p1 = ExpressionVsAvgStopDistance(use_segment_distance = F)
  p2 = ExpressionVsAvgStopDistance(use_segment_distance = T)

  p = multiplot(p1,p2, cols = 2)
}
