require "bio"

class Stop
  AMBER = "TAG"
  OCHRE = "TAA"
  OPAL  = "TGA"

  attr_reader :position

  def self.codon?(codon)
    Bio::Sequence::NA.new(codon).translate == "*"
  end

  def self.avg_distance(codons, use_segments_distance = true)
    if codons.count < 2
      nil
    elsif codons.count == 2
      (codons.first.position - codons.last.position).abs
    else
      use_segments_distance ?
        self._segments_distance(codons) : self._all_pairs_distance(codons)
    end
  end

  def self._segments_distance(codons)
    segments =
      codons
        .size
        .times
        .to_a
        .map { |i| codons[i+1] ? [codons[i], codons[i+1]] : nil }
        .compact

    sum =
      segments
        .map { |arr| arr.map(&:position).reduce(:-).abs }
        .reduce(:+)

    (sum / segments.size.to_f).round(1)
  end

  def self._all_pairs_distance(codons)
    sum =
      codons.combination(2)
            .map {|a, b| (a.position - b.position).abs }
            .reduce(:+)
    (sum / codons.count.to_f).round
  end

  def initialize(codon, position=nil)
    @seq = codon
    @position = position
  end

  def type
    case @seq
    when AMBER then "amber"
    when OCHRE then "ochre"
    when OPAL  then "opal"
    end
  end
end
