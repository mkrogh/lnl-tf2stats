module Steam
  class Tf2Parser < LogParser
    def initialize()
      super()
      entry /.*" killed (?<victim>".*?") with "(?<weapon>[A-Za-z0-9_])/ do |msg, user|
        victim = User.from_steam(msg["victim"])
        user.kills(victim)
      end

      entry /.* triggered "kill assist".*/ do |msg, user|
        user.assists += 1
      end

      entry /.* triggered "flagevent" \(event "captured"\).*/ do |msg, user|
        user.captures += 1
      end

      entry /.* triggered "killedobject".*\(objectowner (?<owner>".*?")\)/ do |msg, user|
        owner = User.from_steam(msg["owner"])
        user.destructions +=1 unless user.steam_id == owner.steam_id
      end
    end
  end
end
