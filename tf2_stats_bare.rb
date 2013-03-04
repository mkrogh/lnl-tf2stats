# encoding: UTF-8
require "steam/tf2_log_parser"

class Tf2Stats
  
  def initialize(*args)
    super
    @parser = Steam::Tf2Parser.new
  end

  #desc "parse <tf2_logfiles>", "parses the specified logfile"
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

end

if __FILE__ == $0
  Tf2Stats.new.parse(ARGV[0])
end
