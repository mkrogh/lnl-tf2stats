require "spec_helper"
require "steam/user"


describe Steam::User do
  let(:user) { Steam::User.new("NevaKee","STEAM_0:0:20205444")}
  context "when creating from steam" do
    subject { Steam::User.from_steam("NevaKee<2><STEAM_0:0:20205444><>")}
    its(:name) { should == "NevaKee"}
    its(:steam_id) { should == "STEAM_0:0:20205444"}
    its(:total_damage) { should == 0}
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
end
