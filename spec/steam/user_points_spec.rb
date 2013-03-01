require "spec_helper"
require "steam/user"


describe Steam::User do
  let(:user) { Steam::User.new("NevaKee","STEAM_0:0:20205444")}
  let(:player2) {Steam::User.new("Handberg","STEAM_0:0:17702671")}

  context "when awarding points" do
    it "kills" do
      user.kills(player2)
      user.kills(player2)
      user.points.should == 2
    end

    it "assists" do
      user.assists = 6
      user.points.should == 3
    end

    it "should award two points for captures" do 
      user.captures = 10
      user.points.should == 20
    end

    it "should count defends" do
      user.defends = 2
      user.points.should == 2
    end

    it "should count revenges" do
      user.revenges = 3
      user.points.should == 3
    end

    it "points should be a total" do
      user.kills(player2)
      user.kills(player2)
      user.kills(user)
      user.assists = 7
      user.captures= 1
      user.defends = 1
      user.revenges = 1

      user.points.should == 9
    end
  end
end
