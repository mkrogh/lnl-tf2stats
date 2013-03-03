# encoding: UTF-8
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

    it "should count destructions" do
      user.destructions = 4
      user.points.should == 4
    end

    it "should count übercharges" do
      user.ubercharges = 6
      user.points.should == 6
    end

    it "should award healing" do
      user.heal(1199)
      user.points.should == 1
    end

    it "should award headshots" do
      user.headshots = 5
      user.points.should == 2
    end

    its "should award backstabs" do
      user.backstabs = 6
      user.points.should == 6
    end

    it "points should be a total" do
      user.kills(player2)
      user.kills(player2)
      user.kills(user)
      user.assists = 5
      user.captures= 1
      user.defends = 1
      user.revenges = 1
      user.destructions = 1
      user.ubercharges = 1

      user.points.should == 10
    end
  end
end
