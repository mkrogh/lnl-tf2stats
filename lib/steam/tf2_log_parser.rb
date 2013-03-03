module Steam
  class Tf2Parser < LogParser
    def initialize()
      super()
      entry /.*" killed (?<victim>".*?") with "(?<weapon>[A-Za-z0-9_])/ do |msg, user|
        victim = User.from_steam(msg["victim"])
        user.kills(victim)
      end
    end
  end
end
