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
  def stop_avg_distance(count=nil, use_segments_distance)
    return nil unless @stops
    if count
      Stop.avg_distance(stops.first(count), use_segments_distance)
    else
      Stop.avg_distance(stops, use_segments_distance)
    end
  end

  def stop_cluster_position_bin
    if @stops.count == 1
      position_bin(@stops.first.position)
    elsif @stops.count == 2
      position = @stops.map(&:position).reduce(:+) / 2.0
      position_bin(position)
    else
      'NA'
    end
  end

  def first_stop_position
    stop = @stops.first
    stop && stop.position
  end

  private

  def position_bin(position)
    bin = @seq.length / 3.0
    if position < bin
      'beginning'
    elsif position >= bin && position < 2*bin
      'middle'
    else
      'tail'
    end
  end

  def find_stops
    @seq
      .scan(/.{3}/)
      .map
      .with_index {|codon, ind| Stop.codon?(codon) ? Stop.new(codon, ind + 1) : nil }
      .compact
  end
end
