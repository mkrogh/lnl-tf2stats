module Steam
  class User
    attr_reader :name, :steam_id, :total_damage
    def initialize(name, steam_id=nil)
      @name = name
      @steam_id = steam_id 
      @total_damage = 0
    end

    def self.from_steam(steam)
      match = /L .*? "(?<name>.*?)<\d+><(?<id>STEAM_.*?)>.*"/.match(steam)
      User.new(match[:name], match[:id])
    end

    def take_damage(amount)
      @total_damage += amount
    end

  end
end
