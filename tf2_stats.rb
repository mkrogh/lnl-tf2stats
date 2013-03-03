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

  desc "parse <tf2_logfile>", "parses the specified logfile"
  def parse(log_file)
    @parser.parse(log_file)

    leaderboard = @parser.users.values.sort { |usr1, usr2| usr2.points <=> usr1.points}

    leaderboard.each do |user| 
      puts "#{user.name}<#{user.steam_id}> - total points: #{user.points}"
    end
  end

  desc "leaderboard <tf2_logfile>", "generates a leaderboard form logfile"
  method_option :output, :aliases => "-o", :type => :string
  def leaderboard(log_file)
    @parser.parse(log_file)
    
    html = LNL::HtmlGenerator.create_leaderboard(@parser.users.values)

    if options[:output]
      open(options[:output], "w") {|f| f.write(html)}
    else
      puts html
    end
  end
end

if __FILE__ == $0
  Tf2Stats.start
end
