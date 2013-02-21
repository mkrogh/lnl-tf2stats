module Steam
  class User
    attr_reader :name, :steam_id, :total_damage
    def initialize(steam_name) 
      match = /(?<name>.*?)<\d+><(?<id>STEAM_.*?)>/.match(steam_name)
      @name = match[:name]
      @steam_id = match[:id]
      @total_damage = 0
    end
  end
end
