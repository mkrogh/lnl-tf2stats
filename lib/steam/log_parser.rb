require "steam/user"
module Steam
  class LogParser
    attr_reader :actions, :users
    def initialize()
      @actions = {}
      @users = {}
    end

    def entry(pattern, &block)
      @actions[pattern] = block
    end

    def handle_line(line)
      user = user(line)
      if user
        @actions.each do |pattern, block|
          if match = pattern.match(line)
            block.call(match,user)
          end
        end
      end
      user
    end

    def parse(file_name)
      File.foreach(file_name) do |line|
        handle_line(line)
      end
      self
    end

    def self.prepare(&block)
      parser = LogParser.new
      parser.instance_eval(&block)
      parser
    end
    private
    def user(line)
      user = User.from_steam(line)
      @users[user.steam_id] ||= user if user
    end
  end
end
