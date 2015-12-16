require "bio"

class Stop
  AMBER = "TAG"
  OCHRE = "TAA"
  OPAL  = "TGA"

  attr_reader :position

  def self.codon?(codon)
    Bio::Sequence::NA.new(codon).translate == "*"
  end

  def self.avg_distance(codons)
    if codons.count < 2
      nil
    elsif codons.count == 2
      (codons.first.position - codons.last.position).abs
    else
      sum =
       codons.combination(2)
             .map {|a, b| (a.position - b.position).abs }
             .reduce(:+)
      (sum / codons.count.to_f).round
    end
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
