require 'spec_helper'

describe Latitude do
  describe "#great_circle_distance" do
    it "should return 0 if both coordinates are equal" do
      expect(Latitude.great_circle_distance(0,0,0,0)).to eq(0)
    end

    it "should use the vincenty formulae to calculate the great-circle distance between two coordinates" do
      expect(Latitude.great_circle_distance(50, -5, 58, -3)).to be_within(0.001).of(899.937706)
      expect(Latitude.great_circle_distance(50, -5, -58, 3)).to be_within(0.001).of(11994.498924)
      expect(Latitude.great_circle_distance(10, 10, 50, 50)).to be_within(0.001).of(5758.331041)
    end
  end

  describe "#initial_bearing" do
    it "should return nil if both coordinates are equal" do
      expect(Latitude.initial_bearing(0,0,0,0)).to be_nil
    end

    it "should use the vincenty formulae to calculate the initial bearing from one point to another along the great circle route" do
      expect(Latitude.initial_bearing(50, -5, 58, -3)).to be_within(0.001).of(7.575056)
      expect(Latitude.initial_bearing(50, -5, -58, 3)).to be_within(0.001).of(175.531128)
      expect(Latitude.initial_bearing(10, 10, 50, 50)).to be_within(0.001).of(31.830619)
    end
  end

  describe "#final_bearing" do
    it "should return nil if both coordinates are equal" do
      expect(Latitude.initial_bearing(0,0,0,0)).to be_nil
    end

    it "should use the vincenty formulae to calculate the initial bearing from one point to another along the great circle route" do
      expect(Latitude.final_bearing(50, -5, 58, -3)).to be_within(0.001).of(9.197103)
      expect(Latitude.final_bearing(50, -5, -58, 3)).to be_within(0.001).of(174.579117)
      expect(Latitude.final_bearing(10, 10, 50, 50)).to be_within(0.001).of(53.758428)
    end
  end
end
