require "bio"

class Codon
  def initialize(nucs_with_pos)
    @codon = nucs_with_pos
  end

  def nucleotides_as_array
    @codon.map(&:first)
  end

  def positions
    @codon.map(&:last)
  end
end
