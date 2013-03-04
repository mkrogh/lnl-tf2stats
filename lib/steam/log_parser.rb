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
      user = nil
      @actions.each do |pattern, block|
        if match = pattern.match(line)
          user = user(line)
          block.call(match,user)
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
      if match =  /(STEAM_.*?)>/.match(line)
        @users[match[1]] ||= User.from_steam(line)
      end
    end
  end
end
