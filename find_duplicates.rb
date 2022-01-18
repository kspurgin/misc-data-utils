require 'csv'
require 'optparse'

require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'pry', '>= 0.13.0'
end

require 'pry'

options = {}
OptionParser.new{ |opts|
  opts.banner = 'Usage: ruby find_duplicates.rb -i {infile} -o {outfile}'

  opts.on('-i', '--infile path_to_input_file', 'Path to file containing ids'){ |i|
    options[:infile] = File.expand_path(i)
  }
  opts.on('-o', '--outfile path_to_output_file ', 'Path to output file'){ |o|
    options[:outfile] = File.expand_path(o)
  }
}.parse!

def empty_report
  puts 'No duplicates'
end

def report_on(counter)
  duplicates = counter.length
  empty_report if duplicates == 0
end

count_holder = {}

File.readlines(options[:infile], chomp: true) do |csid|
  count_holder.key?(csid) ? count_holder[csid] += 1 : count_holder[csid] = 1
end

count_holder.delete_if {|csid, count| count == 1 }

report_on(count_holder)
