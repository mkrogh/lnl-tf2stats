require "haml"
require "steam/user"

module LNL
  class HtmlGenerator
    def self.create_leaderboard(users=[])
      @leaderboard = users.sort {|user1,user2| user2.points <=> user1.points}
      template = open("lib/lnl-stats/haml/leaderboard.haml").read
      leaderboard = Haml::Engine.new(template)
      
      html_output = leaderboard.render(scope=self)
    end
  end
end
