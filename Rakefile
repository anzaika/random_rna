require "rubygems"
require "rspec/core/rake_task"
require_relative "lib/exp"

RSpec::Core::RakeTask.new(:spec)

STANDARD = %i(
  dna
  rna
  length
  expression
  stop_types_count
  stop_count
  opal_stop_pct
  ochre_stop_pct
  amber_stop_pct
  avg_dist_btwn_all_stops
  avg_dist_btwn_first_3_stops
  avg_seg_dist_btwn_all_stops
  avg_seg_dist_btwn_first_3_stops
  stop_cluster_position_bin
  first_stop_position
  rep
)

task default: [:spec]

desc "Write all"
task :write_all do
  %w(upf wt gall).each {|org| write(org) }
end

def write(org)
  vars = STANDARD
  r = Reader.new(org)
  w = Writer.new(inserts: r.inserts, vars: vars, name: org)
  w.write
end
