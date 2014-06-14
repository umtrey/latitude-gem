require 'spec_helper'

describe Latitude do
  describe "#great_circle_distance" do
    it "should return 0 if both coordinates are equal" do
      expect(Latitude.great_circle_distance(0,0,0,0)).to eq(0)
    end
  end
end
