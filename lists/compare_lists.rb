require 'optparse'

require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'pry', '>= 0.13.0'
end

require 'pry'

options = {}
OptionParser.new{ |opts|
  opts.banner = 'Usage: ruby compare_lists.rb -a {lista} -b {listb}'

  opts.on('-a', '--lista path_to_list_a', 'Path to List A'){ |a|
    options[:lista] = File.expand_path(a)
  }
  opts.on('-b', '--listb path_to_list_b', 'Path to List B'){ |b|
    options[:listb] = File.expand_path(b)
  }
}.parse!

class ValueList
  attr_reader :list, :name, :length
  
  def initialize(path, name)
    @path = path
    @list = File.readlines(path, chomp: true).uniq
    @name = name
    @length = @list.length
  end
end

class Comparer
  attr_reader :a_only, :b_only
  def initialize(patha, pathb)
    @a, @b = ValueList.new(patha, 'List A'), ValueList.new(pathb, 'List B')
    @a_only = in_x_not_y(@a, @b)
    @b_only = in_x_not_y(@b, @a)
  end

  def intersection
    @intersection ||= @a.list.intersection(@b.list).sort
  end

  def report
    [@a, @b].each{ |list| puts "#{list.name} length: #{list.length}" }
    puts "In both: #{intersection.length}"
    puts "In A only: #{@a_only.length}"
    puts "In B only: #{@b_only.length}"
  end
  
  def same?
    return false unless @a.length == @b.length
    return true if intersection.length == @a.length

    false
  end

  private def in_x_not_y(x, y)
            return [] if same?

            x.list - y.list
          end

end

comp = Comparer.new(options[:lista], options[:listb])
comp.report

puts 'In A only'
puts comp.a_only

puts ''
puts 'In B only'
puts comp.b_only
