require "spec_helper"
require "steam/tf2_log_parser"

describe Steam::Tf2Parser do
  let(:parser){Steam::Tf2Parser.new}
  let(:kill){'L 02/21/2013 - 21:23:04: "NevaKee<2><STEAM_0:0:20205444><Blue>" killed "Handberg<4><STEAM_0:0:17702671><Red>" with "tf_projectile_rocket" (attacker_position "-2558 -1493 256") (victim_position "-2274 -1133 279")'}
  let(:assist){'L 02/28/2013 - 20:44:54: "NevaKee<2><STEAM_0:0:20205444><Blue>" triggered "kill assist" against "Handberg<4><STEAM_0:0:17702671><Red>" (assister_position "-2228 3191 -343") (attacker_position "-2346 3187 -287") (victim_position "-2407 3008 -287")'}



  it "should track kills" do
    parser.handle_line(kill).kills.should include("STEAM_0:0:17702671")
  end

  it "should track kill assists" do
    parser.handle_line(assist).assists.should == 1
  end 

  it "should track multiple events" do
    parser.handle_line(kill)
    parser.handle_line(assist)
    user = parser.handle_line(assist)

    user.total_kills.should == 1
    user.assists.should == 2
  end
end
