require 'spec_helper'

describe Latitude do
  describe "#great_circle_distance" do
    it "should return 0 if both coordinates are equal" do
      expect(Latitude.great_circle_distance(0,0,0,0)).to eq(0)
    end

    it "should use the vincenty formulae to calculate the great-circle distance between two coordinates" do
      expect(Latitude.great_circle_distance(50, -5, 58, -3)).to be_within(0.1).of(899.937706)
      expect(Latitude.great_circle_distance(50, -5, -58, 3)).to be_within(0.1).of(11994.498924)
    end
  end
end
