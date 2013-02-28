require "spec_helper"
require "steam/log_parser"

describe Steam::LogParser do 
  #context "when parsing actions" do
  #  it "registers damage" do
  #    parser.parse_line('L 02/21/2013 - 21:13:54: "NevaKee<2><STEAM_0:0:20205444><Blue>" triggered "damage" (damage "76")')
  #  end
  #end

  let(:parser) do
      Steam::LogParser.prepare do 
        entry /.* triggered "damage" \(damage "(\d+)"\)/ do |msg, user|
          user.take_damage Integer(msg[1])
        end
      end
  end

  let(:dmg_line){'L 02/21/2013 - 21:13:54: "NevaKee<2><STEAM_0:0:20205444><Blue>" triggered "damage" (damage "76")'}

  context "when parsing a line" do 
    it "should be able to define rules" do
      parser.handle_line(dmg_line).total_damage.should == 76
    end
  end
end
