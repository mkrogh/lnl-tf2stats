require "spec_helper"
require "steam/tf2_log_parser"

describe Steam::Tf2Parser do
  let(:parser){Steam::Tf2Parser.new}
  let(:kill){'L 02/21/2013 - 21:23:04: "NevaKee<2><STEAM_0:0:20205444><Blue>" killed "Handberg<4><STEAM_0:0:17702671><Red>" with "tf_projectile_rocket" (attacker_position "-2558 -1493 256") (victim_position "-2274 -1133 279")'}
  let(:assist){'L 02/28/2013 - 20:44:54: "NevaKee<2><STEAM_0:0:20205444><Blue>" triggered "kill assist" against "Handberg<4><STEAM_0:0:17702671><Red>" (assister_position "-2228 3191 -343") (attacker_position "-2346 3187 -287") (victim_position "-2407 3008 -287")'}
  let(:flag_capture){'L 02/21/2013 - 21:04:24: "Handberg<3><STEAM_0:0:17702671><Red>" triggered "flagevent" (event "captured") (team_caps "1") (caps_per_round "3") (position "-379 3329 -145")'}
  let(:destruction){'L 02/21/2013 - 21:02:29: "Handberg<3><STEAM_0:0:17702671><Red>" triggered "killedobject" (object "OBJ_SENTRYGUN") (weapon "tf_projectile_rocket") (objectowner "NevaKee<2><STEAM_0:0:20205444><Blue>") (attacker_position "-487 -3149 -191")'}
  let(:self_destruction){'L 02/28/2013 - 20:47:36: "NevaKee<2><STEAM_0:0:20205444><Blue>" triggered "killedobject" (object "OBJ_TELEPORTER") (weapon "pda_engineer") (objectowner "NevaKee<2><STEAM_0:0:20205444><Blue>") (attacker_position "-902 3275 -255")'}



  it "should track kills" do
    user = parser.handle_line(kill)
    user.kills.should include("STEAM_0:0:17702671")
    user.name.should == "NevaKee"
  end

  it "should track kill assists" do
    user = parser.handle_line(assist)
    user.assists.should == 1
    user.name.should == "NevaKee"
  end 

  it "should track flag captures" do
    user = parser.handle_line(flag_capture)
    user.captures.should == 1
    user.name.should == "Handberg"
  end

  it "should track destructions" do
    user = parser.handle_line(destruction)
    user.destructions.should == 1
  end

  it "should not track owner deconstruction" do
    user = parser.handle_line(self_destruction)
    user.destructions.should == 0
  end

  it "should track multiple events" do
    parser.handle_line(kill)
    parser.handle_line(assist)
    user = parser.handle_line(assist)

    user.total_kills.should == 1
    user.assists.should == 2
  end
end
