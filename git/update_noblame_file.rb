require 'bundler/inline'
require 'fileutils'
require 'optparse'

gemfile do
  source 'https://rubygems.org'
  gem 'debug'
end

options = {}
optparse = OptionParser.new do |parser|
  parser.banner = 'Usage: ruby update_noblame_file.rb -r path_to_repo'
  parser.on('-r', '--repo [STRING]', String, 'Path to repository') do |r|
    options[:repo] = File.expand_path(r)
  end
end

begin
  optparse.parse!
  mandatory = [:repo]
  missing = mandatory.select { |param| options[param].nil? }
  raise OptionParser::MissingArgument.new(missing.join(', ')) unless missing.empty?
rescue OptionParser::InvalidOption, OptionParser::MissingArgument
  puts $!
  puts optparse
  exit(1)
end

noblame_file = '.git-blame-ignore-revs'

repo = options[:repo]

unless Dir.exist?(repo)
  puts "#{repo} does not exist"
  exit(1)
end

FileUtils.cd(repo)

log = `git log --grep "^noblame" --pretty=oneline`
prepped_log = log.split("\n").map { |line| line.split(' noblame') }
                 .map { |arr| [arr[0], "# noblame#{arr[1]}"] }
                 .to_h

def to_strings(hash)
  hash.map { |commit, comment| [comment, "#{commit}\n"].join("\n") }
end

if File.exist?(noblame_file)
  existing = File.readlines(noblame_file, chomp: true)
                 .reject { |line| line.empty? || line.start_with?('#') }
  File.open(noblame_file, 'a') do |outfile|
    to_add = prepped_log.reject do |commit, _c|
      existing.include?(commit)
    end
    if to_add.empty?
      puts 'No new noblame commits to add'
    else
      puts "Adding #{to_add.size} noblame commits"
      outfile << "\n"
      outfile << to_strings(to_add).join("\n")
    end
  end
else
  puts "Created file with #{prepped_log.size} noblame commits"
  File.open(noblame_file, 'w') do |outfile|
    outfile << to_strings(prepped_log).join("\n")
  end
end
