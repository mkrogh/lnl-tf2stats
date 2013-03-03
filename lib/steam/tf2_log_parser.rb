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

      entry /.* triggered "flagevent" \(event "defended"\).*/ do |msg, user|
        user.defends += 1
      end

      entry /.* triggered "killedobject".*\(objectowner (?<owner>".*?")\)/ do |msg, user|
        owner = User.from_steam(msg["owner"])
        user.destructions += 1 unless user.steam_id == owner.steam_id
      end

      entry /.* triggered "revenge" .*/ do |msg, user|
        user.revenges += 1
      end

      entry /.* triggered "chargedeployed".*/ do |msg, user|
        user.ubercharges += 1
      end

      entry /.* triggered "damage" \(damage "(?<damage>\d+)"\).*/ do |msg, user|
        damage = Integer(msg["damage"])
        user.deal_damage(damage)
      end

      entry /.* triggered "healed" against (?<target>".*?") \(healing "(?<amount>\d+)"\).*/ do |msg, user|
        amount = Integer(msg["amount"])
        user.heal(amount)
      end

      entry /.* \(customkill "headshot"\).*/ do |msg, user|
        user.headshots += 1
      end

      entry /.* \(customkill "backstab"\).*/ do |msg, user|
        user.backstabs += 1
      end
    end
  end
end
