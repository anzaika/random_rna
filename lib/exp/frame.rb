require "bio"

class Frame
  attr_reader :stops

  def initialize(seq)
    @seq = seq
  end

  def stops
    @stops ||= find_stops
  end

  def stop_count
    stops.count
  end

  # How many types of stops there are in the frame.
  def stop_types_count
    stops && stops.map(&:type).uniq.count
  end

  # Percentage of any particular type of stop in the frame.
  def stop_type_pct(stop_type)
    return nil unless stops.count > 0
    type_count = stops.map(&:type).count {|t| t == stop_type.to_s }
    ((type_count / stops.count.to_f) * 100).round
  end

  # Average distance between first N stops. Or between all of them.
  def stop_avg_distance(count=nil)
    return nil unless @stops
    if count
      Stop.avg_distance(stops.first(count))
    else
      Stop.avg_distance(stops)
    end
  end

  private

  def find_stops
    @seq
      .scan(/.{3}/)
      .map
      .with_index {|codon, ind| Stop.codon?(codon) ? Stop.new(codon, ind + 1) : nil }
      .compact
  end
end
