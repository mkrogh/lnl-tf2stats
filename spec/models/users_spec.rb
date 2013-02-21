require "spec_helper"
require "steam/user"


describe Steam::User do
  context "when creating from steam" do
    subject { Steam::User.new "NevaKee<2><STEAM_0:0:20205444><>"}
    its(:name) { should == "NevaKee"}
    its(:steam_id) { should == "STEAM_0:0:20205444"}
    its(:total_damage) { should == 0}
  end
end
