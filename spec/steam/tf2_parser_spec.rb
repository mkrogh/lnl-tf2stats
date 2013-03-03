require "spec_helper"
require "steam/tf2_log_parser"

describe Steam::Tf2Parser do
  let(:parser){Steam::Tf2Parser.new}

  it "should parse kills" do
    line = 'L 02/21/2013 - 21:23:04: "NevaKee<2><STEAM_0:0:20205444><Blue>" killed "Handberg<4><STEAM_0:0:17702671><Red>" with "tf_projectile_rocket" (attacker_position "-2558 -1493 256") (victim_position "-2274 -1133 279")'
    parser.handle_line(line).kills.should include("STEAM_0:0:17702671")
  end
end
