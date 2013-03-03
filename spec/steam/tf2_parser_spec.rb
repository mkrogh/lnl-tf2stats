# encoding: UTF-8
require "spec_helper"
require "steam/tf2_log_parser"

describe Steam::Tf2Parser do
  let(:parser){Steam::Tf2Parser.new}
  let(:kill){'L 02/21/2013 - 21:23:04: "NevaKee<2><STEAM_0:0:20205444><Blue>" killed "Handberg<4><STEAM_0:0:17702671><Red>" with "tf_projectile_rocket" (attacker_position "-2558 -1493 256") (victim_position "-2274 -1133 279")'}
  let(:assist){'L 02/28/2013 - 20:44:54: "NevaKee<2><STEAM_0:0:20205444><Blue>" triggered "kill assist" against "Handberg<4><STEAM_0:0:17702671><Red>" (assister_position "-2228 3191 -343") (attacker_position "-2346 3187 -287") (victim_position "-2407 3008 -287")'}
  let(:flag_capture){'L 02/21/2013 - 21:04:24: "Handberg<3><STEAM_0:0:17702671><Red>" triggered "flagevent" (event "captured") (team_caps "1") (caps_per_round "3") (position "-379 3329 -145")'}
  let(:defend){'L 02/21/2013 - 21:09:49: "NevaKee<2><STEAM_0:0:20205444><Blue>" triggered "flagevent" (event "defended") (position "-479 -3197 -191")'}
  let(:destruction){'L 02/21/2013 - 21:02:29: "Handberg<3><STEAM_0:0:17702671><Red>" triggered "killedobject" (object "OBJ_SENTRYGUN") (weapon "tf_projectile_rocket") (objectowner "NevaKee<2><STEAM_0:0:20205444><Blue>") (attacker_position "-487 -3149 -191")'}
  let(:self_destruction){'L 02/28/2013 - 20:47:36: "NevaKee<2><STEAM_0:0:20205444><Blue>" triggered "killedobject" (object "OBJ_TELEPORTER") (weapon "pda_engineer") (objectowner "NevaKee<2><STEAM_0:0:20205444><Blue>") (attacker_position "-902 3275 -255")'}
  let(:revenge){'L 02/21/2013 - 21:23:04: "NevaKee<2><STEAM_0:0:20205444><Blue>" triggered "revenge" against "Handberg<4><STEAM_0:0:17702671><Red>"'}
  let(:ubercharge){'L 02/21/2013 - 21:34:12: "NevaKee<2><STEAM_0:0:20205444><Blue>" triggered "chargedeployed"'}
  let(:damage){'L 02/21/2013 - 21:22:56: "NevaKee<2><STEAM_0:0:20205444><Blue>" triggered "damage" (damage "42")'}
  let(:heal){'L 02/21/2013 - 21:32:48: "NevaKee<2><STEAM_0:0:20205444><Blue>" triggered "healed" against "Handberg<4><STEAM_0:0:17702671><Blue>" (healing "42")'}
  let(:headshot){'L 02/28/2013 - 20:40:45: "Handberg<4><STEAM_0:0:17702671><Blue>" killed "NevaKee<2><STEAM_0:0:20205444><Blue>" with "machina" (customkill "headshot") (attacker_position "-1829 1119 -415") (victim_position "-2375 39 -415")'}
  let(:backstab){'L 02/28/2013 - 20:40:49: "Handberg<4><STEAM_0:0:17702671><Blue>" killed "NevaKee<2><STEAM_0:0:20205444><Blue>" with "sharp_dresser" (customkill "backstab") (attacker_position "-713 410 -415") (victim_position "-706 344 -363")'}

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

  it "should track defends" do
    user = parser.handle_line(defend)
    user.defends.should == 1
    user.name.should == "NevaKee"
  end

  it "should track destructions" do
    user = parser.handle_line(destruction)
    user.destructions.should == 1
  end

  it "should not track owner deconstruction" do
    user = parser.handle_line(self_destruction)
    user.destructions.should == 0
  end

  it "should track revenges" do
    user = parser.handle_line(revenge)
    user.revenges.should == 1
    user.name.should == "NevaKee"
  end

  it "should track übercharges" do
    user = parser.handle_line(ubercharge)
    user.ubercharges.should == 1
  end
  
  it "should track damage dealt" do
    user = parser.handle_line(damage)
    user.total_damage.should == 42
    user.name.should == "NevaKee"
  end

  it "should track healing" do
    user = parser.handle_line(heal)
    user.total_healed.should == 42
    user.name.should == "NevaKee"
  end

  it "should track headshots" do
    user = parser.handle_line(headshot)
    user.headshots.should == 1
  end

  it "should track both kill and headshot" do
    user = parser.handle_line(headshot)
    user.total_kills.should == 1
    user.headshots.should == 1
  end

  its "should track both kill and backstab" do
    user = parser.handle_line(backstab)
    user.total_kills.should == 1
    user.backstabs.should == 1
  end

  it "should track multiple events" do
    parser.handle_line(kill)
    parser.handle_line(assist)
    user = parser.handle_line(assist)

    user.total_kills.should == 1
    user.assists.should == 2
  end

  context "when parsing trial_run.log", :full_parse => true do
    let(:trial_run){Steam::Tf2Parser.new.parse("spec/trial_run.log")}
    let(:player1) {trial_run.users.values.first}
    let(:player2) {trial_run.users.values.last}
    
    subject {trial_run}
    its(:users){should have(2).users}
    describe "player1" do 
      subject {player1}
      its(:total_kills){should == 6}
      its(:captures){should == 2}
      its(:destructions){should == 0}
      its(:assists){should == 0}
      its(:defends){should == 2}
      its(:revenges){should == 1}
      its(:total_damage){should == 2185}
      its(:points){should == 13}
    end

    describe "player2" do
      subject {player2}
      its(:total_kills){should == 4}
      its(:captures){should == 1}
      its(:destructions){should == 1}
      its(:assists){should == 0}
      its(:defends){should == 0}
      its(:revenges){should == 0}
      its(:total_damage){should == 945}
      its(:points){should == 7}
    end
  end
end
