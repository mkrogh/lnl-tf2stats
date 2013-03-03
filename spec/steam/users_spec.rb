require "spec_helper"
require "steam/user"

shared_examples "a new user" do
    its(:name) { should == "NevaKee"}
    its(:steam_id) { should == "STEAM_0:0:20205444"}
    its(:total_damage) { should == 0}
    its(:kills){ should == {}}
    its(:suicides){should == 0}
    its(:assists){should == 0}
    its(:captures){should == 0}
    its(:defends){should == 0}
    its(:revenges){should == 0}
    its(:destructions){should == 0}
end

describe Steam::User do
  let(:user) { Steam::User.new("NevaKee","STEAM_0:0:20205444")}
  let(:player2) {Steam::User.new("Handberg","STEAM_0:0:17702671")}

  describe "#from_steam" do 
    context "when creating from full log line" do
      subject { Steam::User.from_steam('L 02/28/2013 - 20:44:54: "NevaKee<2><STEAM_0:0:20205444><Blue>" triggered "kill assist" against "Handberg<4><STEAM_0:0:17702671><Red>" (assister_position "-2228 3191 -343") (attacker_position "-2346 3187 -287") (victim_position "-2407 3008 -287")')}
      it_behaves_like "a new user"
    end

    context "creation from user data" do
      subject{Steam::User.from_steam('"NevaKee<2><STEAM_0:0:20205444><Blue>"')}
      it_behaves_like "a new user"
    end
  end

  context "when handling damange" do
    it "should take damage" do 
      user.take_damage 50
      user.total_damage.should == 50
    end

    it "should keep track of damage" do 
      user.take_damage 104
      user.take_damage 66
      user.take_damage 30
      user.total_damage.should == 200
    end
  end

  context "when tracking kills" do
    it "should handle first kill" do
      user.kills(player2)
      user.kills.should include(player2.steam_id)
      user.kills[player2.steam_id].should == 1
    end
    
    it "should handle multiple kills" do
      user.kills(player2)
      user.kills(player2)
      user.kills(player2)
      user.kills[player2.steam_id].should == 3
    end

    it "should track suicides" do
      user.kills(user)
      user.kills(user)
      user.kills[user.steam_id].should == 2
      user.suicides == 2
    end

    it "should report total kills without suicides" do
      user.kills(player2)
      user.kills(player2)
      user.kills(user)

      user.total_kills.should == 2
    end
  end

end
