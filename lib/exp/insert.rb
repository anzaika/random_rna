class Insert
  attr_reader :dna, :rna, :insert, :expression

  PRIME5 = "ATGAT"
  PRIME3 = "ATTAGATAACTGACTCGAGTCATGTAATTAGTTATGTCACGCTTACATTCACGCCCTCCCCCCACATCCGCTCTAACCGAAAAGGAAGGAGTTAGACAACCTGAAGTCTAGGTCCCTATTTATTTTTTTATAGTTATGTTAGTATTAAGAACGTTATTTATATTTCAAATTT"

  def initialize(vanilla_string, rep)
    @rep = rep
    if rep == "gall"
      parse_gall(vanilla_string)
    else
      parse_regular(vanilla_string)
    end
  end

  def parse_gall(l)
    l = l.chomp.split("\t")
    @header =         l[0]
    @dna =            l[5]
    @rna =            l[6]
    @insert =         l[8]
    @premature_stop = l[11]
    @orf_seq =        l[13]
    @expression =     l[27]
  end

  def parse_regular(l)
    l = l.chomp.split("\t")
    @header =         l[0]
    @dna =            l[5]
    @rna =            l[6]
    @insert =         l[8]
    @genome_strand =  l[12]
    @premature_stop = l[15]
    @orf_seq =        l[17]
    @expression =     l[32]
  end

  def frame
    @frame ||= Frame.new(orf) if orf
  end

  def to_line(vars)
    vars.map {|var| (v = send(var)) ? v : "NA" }.join("\t") + "\n"
  end

  def rep
    @rep.upcase
  end

  def stop_types_count
    frame && frame.stop_types_count
  end

  def stop_count
    frame && frame.stop_count
  end

  def amber_stop_pct
    frame && frame.stop_type_pct(:amber)
  end

  def ochre_stop_pct
    frame && frame.stop_type_pct(:ochre)
  end

  def opal_stop_pct
    frame && frame.stop_type_pct(:opal)
  end

  def avg_dist_btwn_all_stops
    frame && frame.stop_avg_distance(nil, false)
  end

  def avg_seg_dist_btwn_all_stops
    frame && frame.stop_avg_distance(nil, true)
  end

  def avg_dist_btwn_first_3_stops
    frame && frame.stop_avg_distance(3, false)
  end

  def avg_seg_dist_btwn_first_3_stops
    frame && frame.stop_avg_distance(3, true)
  end

  def length
    @insert.length
  end

  # Works only for inserts with 1-2 stops
  def stop_cluster_position_bin
    frame && frame.stop_cluster_position_bin
  end

  def first_stop_position
    frame && frame.first_stop_position
  end

  private

  def orf
    # PRIME5 + @insert + PRIME3
    PRIME5 + @insert
  end
end
