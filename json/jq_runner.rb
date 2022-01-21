#!/usr/bin/env ruby

# Print to screen the results of `file` command for all
require 'optparse'
require 'pathname'
require 'pp'
require 'pry'

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: jq_runner.rb -i path-to-input-dir -s file-suffix'

  opts.on('-i', '--input PATH', 'Path to input directory containing files') do |i|
    options[:input] = File.expand_path(i)
  end

  opts.on('-s', '--suffix STRING', 'File suffix, without dot') do |s|
    options[:suffix] = ".#{s.delete_prefix('.')}"
  end

  opts.on('-h', '--help', 'Prints this help') do
    puts opts
    exit
  end
end.parse!

path = "#{options[:input]}/**/*#{options[:suffix]}"
files = Dir[path]

files.each do |file|
  next unless file['core']
  result = `jq '[ ..|.view? | objects | select(.type == "TermPickerInput") | .props.source]' #{file}`
  next if result.chomp == '[]'

  puts ''
  puts file
  puts result
end

# all values of name key that equal addressPlace1OMCA
# jq '[ ..|.name? ] | map(select( . == "addressPlace1OMCA"))'

# all values of source that equal /
# jq '[ ..|.source? ] | map(select( . == "/"))'

# all values of source that are not null
# jq '[ ..|.source? ] | map(select( . != null))'

  #result = `jq '[ .. | .source? | strings ] | to_entries' #{file}`
#  result = `jq '[ .. | .source? | strings ] | select( | test(".*material_shared.*"))' #{file}`
  #result = `jq '[ .. | .source? | strings ] | map(select( . != null) | test(".*material_shared.*") == true)' #{file}`
  #  result = `jq '[ .. | .source? | strings] | map(select( . != null ))' #{file}`
