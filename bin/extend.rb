require "bio"
require "ostruct"

WT = "2015-10-16/WT_MM5.tab"
UPF = "2015-10-16/UPF1_MM5.tab"
GALL = "2015-10-20/gDNA_GALLpr_2014.tab"

class Extend
  def initialize(filename, rep)
    @filename = filename
    @rep = rep
    @file = File.open(File.join("data", filename))
    @data = []
  end

  def crunch(gall=false)
    gall ? load_gall : load
    insert
    write
  end

  def load_gall
    @file.readlines[1..-1].each do |l|
      l = l.chomp.split("\t")
      @data << OpenStruct.new(
          dna:           l[5],
          rna:           l[6],
          insert:        l[8],
          chr:           l[0],
          start_pos:     l[0],
          end_pos:       l[0],
          genome_strand: l[0],
          insert_l:      l[9],
          insert_gc:     l[10],
          premature_stop:l[11],
          orf_seq:       l[13],
          aa_seq:        Bio::Sequence::NA.new(l[13]).translate,
          expression:    l[27])
    end
  end

  def load
    @file.readlines[1..-1].each do |l|
      l = l.chomp.split("\t")
      @data << OpenStruct.new(
          dna:           l[5],
          rna:           l[6],
          insert:        l[8],
          chr:           l[9],
          start_pos:     l[10],
          end_pos:       l[11],
          genome_strand: l[12],
          insert_l:      l[13],
          insert_gc:     l[14],
          premature_stop:l[15],
          orf_seq:       l[17],
          aa_seq:        Bio::Sequence::NA.new(l[17]).translate,
          expression:    l[32])
    end
  end

  def insert
    @data.each do |s|
      s.first_stop_position_pct = first_stop_position_pct(s)
      s.stop_count = stop_count(s)
      s.stop_density = stop_density(s)
      s.rep = @rep
    end
  end

  def write
    File.open(File.join("extended_data", "#{@filename.split('/').last.split('.').first + '_extended.tsv'}"), "w") do |f|
      f << @data.first.to_h.keys.join("\t")
      f << "\n"
      f << @data.map{|r| r.to_h.values.join("\t")}.join("\n")
    end
  end

  def first_stop_position_pct(r)
    return "NA" if r.premature_stop == "FALSE"
    aa_seq = r.aa_seq
    pos = (/\*/ =~ aa_seq)
    if pos
      return ((pos / aa_seq.length.to_f) * 100).round(2)
    else
      return "NA"
    end
  end

  def stop_count(r)
    tr(r).scan(/\*/).count
  end

  def stop_density(r)
    stop_positions = tr(r).enum_for(:scan, /\*/).map { Regexp.last_match.begin(0) }
    if  stop_positions.count == 2
      return stop_positions[-1] - stop_positions[0]
    elsif stop_positions.count > 2
      distances =
       stop_positions[0..-2].zip(stop_positions[1..-1]).map { |a| a.reduce(:-) * (-1) }
      return distances.reduce(:+)/distances.count.to_f
    else
      return "NA"
    end
  end


  def tr(r)
    seq = "ATG"+r.insert.split("ATG")[1..-1].join("ATG")
    Bio::Sequence::NA.new(seq).translate
  end

end

Extend.new(WT, "WT").crunch
Extend.new(UPF, "UPF1").crunch
Extend.new(GALL, "GALL").crunch(true)
