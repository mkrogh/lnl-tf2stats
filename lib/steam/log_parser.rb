module Steam
  class LogParser
    def initialize()
      @actions = {}
      @users = {}
    end

    def entry(pattern, &block)
      @actions[pattern] = block
    end

    def handle_line(line)
      user = user(line)
      @actions.keys.each do |pattern|
        if match = pattern.match(line)
          @actions[pattern].call(match,user)
        end
      end
      user
    end

    def self.prepare(&block)
      parser = LogParser.new
      parser.instance_eval(&block)
      parser
    end
    private
    def user(line)
      user = User.from_steam(line)
      @users[user.steam_id] ||= user
    end
  end
end
