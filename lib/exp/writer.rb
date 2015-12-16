class Writer

  # Takes in they array of insert objects and an array of variables to write in the file
  def initialize(inserts: , vars: , name:)
    @inserts = inserts
    @vars = vars.map(&:to_s)
    @name = name
  end

  def write
    File.open(File.join("outputs", @name + ".tsv"), 'w') do |f|
      f << header
      @inserts.each {|i| f << i.to_line(@vars) }
    end
  end

  def header
    @vars.join("\t") + "\n"
  end
end
