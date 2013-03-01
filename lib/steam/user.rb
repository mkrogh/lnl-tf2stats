module Steam
  class User
    attr_reader :name, :steam_id, :total_damage
    attr_accessor :assists, :captures, :defends, :revenges
    def initialize(name, steam_id=nil)
      @name = name
      @steam_id = steam_id 
      @total_damage = 0
      @kills = {}
      @assists = 0
      @captures = 0
      @defends = 0
      @revenges = 0
    end

    def self.from_steam(steam)
      match = /L .*? "(?<name>.*?)<\d+><(?<id>STEAM_.*?)>.*"/.match(steam)
      User.new(match[:name], match[:id])
    end

    def take_damage(amount)
      @total_damage += amount
    end

    def kills(user=nil)
      if user
        #do stuff
        @kills[user.steam_id] ||= 0
        @kills[user.steam_id] += 1
      else
        @kills
      end 
    end

    def suicides
      @kills[@steam_id] ||= 0
    end

    def total_kills
      total = @kills.values.reduce(:+) || 0
      total -= suicides
    end

    def points
      total_kills + (@assists/2) + (captures*2) + defends + revenges
    end
  end
end
