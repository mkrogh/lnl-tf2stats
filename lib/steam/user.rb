module Steam
  class User
    attr_reader :name, :steam_id, :total_damage, :total_healed
    attr_accessor :assists, :captures, :defends, :revenges, :destructions, :ubercharges, :headshots, :backstabs
    def initialize(name, steam_id=nil)
      @name = name
      @steam_id = steam_id 
      @total_damage = 0
      @total_healed = 0
      @kills = {}
      @assists = 0
      @captures = 0
      @defends = 0
      @revenges = 0
      @destructions = 0
      @ubercharges = 0
      @headshots = 0
      @backstabs = 0
    end

    def self.from_steam(steam)
      match = /"(?<name>.*?)<\d+><(?<id>STEAM_.*?)>/.match(steam)
      User.new(match[:name], match[:id]) if match
    end

    def deal_damage(amount)
      @total_damage += amount
    end

    def heal(amount)
      @total_healed += amount
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
      total_kills \
      + (@assists/2) \
      + (captures*2) \
      + defends \
      + revenges \
      + destructions \
      + ubercharges \
      + (total_healed/600) \
      + (headshots/2) \
      + backstabs
    end

    def to_s
      "#<Steam::User @name=#{name} @steam_id=#{steam_id}>"
    end
  end
end
