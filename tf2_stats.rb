require "rubygems"
require 'bundler/setup'

Bundler.require(:default)
require "steam/tf2_log_parser"

class Tf2Stats < Thor
  
  desc "parse <tf2_logfile>", "parses the specified logfile"
  def parse(log_file)
    tf2 = Steam::Tf2Parser.new
    tf2.parse(log_file)

    leaderboard = tf2.users.values.sort { |usr1, usr2| usr2.points <=> usr1.points}

    leaderboard.each do |user| 
      puts "#{user.name}<#{user.steam_id}> - total points: #{user.points}"
    end
  end
end

if __FILE__ == $0
  Tf2Stats.start
end
