# encoding: UTF-8
require "rubygems"
require 'bundler/setup'

Bundler.require(:default)
require "steam/tf2_log_parser"
require "lnl-stats/html_generator"

class Tf2Stats < Thor
  
  def initialize(*args)
    super
    @parser = Steam::Tf2Parser.new
  end

  desc "parse <tf2_logfiles>", "parses the specified logfile"
  def parse(log_files)
    Dir.glob(log_files).sort.each do |file|
      @parser.parse(file) if File.file?(file)
    end

    leaderboard = @parser.users.values.sort { |usr1, usr2| usr2.points <=> usr1.points}

    unless leaderboard.empty?
      leaderboard.each do |user| 
        puts "#{user.name}<#{user.steam_id}> - total points: #{user.points}"
      end
    else
      puts "No users parsed"
    end
  end

  desc "leaderboard <tf2_logfiles>", "generates a leaderboard form logfile"
  method_option :output, :aliases => "-o", :type => :string
  method_option :force, :aliases => "-f", :type => :boolean, :default => false
  def leaderboard(log_files)
    Dir.glob(log_files).sort.each do |file|
      @parser.parse(file) if File.file?(file)
    end
    
    html = LNL::HtmlGenerator.create_leaderboard(@parser.users.values)

    if options[:output]
      copy_resources(options[:output])
      open(options[:output]+"/index.html", "w:UTF-8") {|f| f.write(html)}
    else
      puts html
    end
  end

  private
  def copy_resources(destination)
    puts "Generating resources"
    FileUtils.cp_r  "resources/.", destination
  end
end

if __FILE__ == $0
  Tf2Stats.start
end
