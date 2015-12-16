class Reader
  WT = "2015-10-16/WT_MM5.tab"
  UPF = "2015-10-16/UPF1_MM5.tab"
  GALL = "2015-10-20/gDNA_GALLpr_2014.tab"

  attr_reader :inserts

  def initialize(exp_name)
    case exp_name
    when "wt" then @f = WT
    when "upf" then @f = UPF
    when "gall" then @f = GALL
    else
      raise "Unknown experiment name passed to Reader#initialize: #{exp_name}"
    end
    read(exp_name)
  end

  # Returns an array of Insert objects
  def read(exp_name)
    @inserts =
      File.open(File.join("data", @f))
          .readlines[1..-1]
          .map {|l| Insert.new(l, exp_name) }
  end
end
