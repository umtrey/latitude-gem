#!/bin/env ruby
# encoding: utf-8
require 'spec_helper'

describe Coordinate do
  let(:coordinate) { Coordinate.new(:latitude => 0, :longitude => 0) }
  let(:blank_coordinate) { Coordinate.new }

  describe "initialization" do
    it "should initialize with provided parameters" do
      new_coordinate = Coordinate.new(:latitude => 10,
                                      :longitude => 20)
      expect(new_coordinate.latitude).to eq(10)
      expect(new_coordinate.longitude).to eq(20)
    end
  end

  describe "coordinate parsing" do
    it "should accept a simple string for latitudes and longitudes" do
      coordinate.latitude = "-10"
      coordinate.longitude = "10"
      expect(coordinate.latitude).to eq(-10)
      expect(coordinate.longitude).to eq(10)
    end

    it "should accept a decimal string for latitudes and longitudes" do
      coordinate.latitude = "-10.5"
      coordinate.longitude = "10.5"
      expect(coordinate.latitude).to eq(-10.5)
      expect(coordinate.longitude).to eq(10.5)
    end

    describe "with cardinal directions" do
      it "should save the latitude if given N as cardinal direction" do
        coordinate.latitude = "10.5 N"
        expect(coordinate.latitude).to eq(10.5)
      end

      it "should make the latitude negative if given S as a cardinal direction" do
        coordinate.latitude = "10.5 S"
        expect(coordinate.latitude).to eq(-10.5)
      end

      it "should throw an exception if given E or W as a direction for latitude" do
        expect { coordinate.latitude = "10 E" }.to raise_error(ArgumentError)
        expect { coordinate.latitude = "10 W" }.to raise_error(ArgumentError)
      end

      it "should save the longitude if given E as a cardinal direction" do
        coordinate.longitude = "10.5 E"
        expect(coordinate.longitude).to eq(10.5)
      end

      it "should make the longitude negative if given W as a cardinal direction" do
        coordinate.longitude = "10.5 W"
        expect(coordinate.longitude).to eq(-10.5)
      end

      it "should throw an exception if given N or S as a direction for longitude" do
        expect { coordinate.longitude = "10 N" }.to raise_error(ArgumentError)
        expect { coordinate.longitude = "10 S" }.to raise_error(ArgumentError)
      end
    end
  end

  describe "validation" do
    it "should be valid if given valid lat and long" do
      expect(coordinate).to be_valid
    end

    it "should be invalid unless latitude provided" do
      blank_coordinate.longitude = 0
      expect(blank_coordinate).to_not be_valid
    end

    it "should be invalid unless longitude provided" do
      blank_coordinate.latitude = 0
      expect(blank_coordinate).to_not be_valid
    end

    it "should be invalid unless latitude is between -90 and 90" do
      coordinate.latitude = -100
      expect(blank_coordinate).to_not be_valid

      coordinate.latitude = 100
      expect(blank_coordinate).to_not be_valid
    end

    it "should be invalid unless longitude is between -180 and 180" do
      coordinate.longitude = -190
      expect(blank_coordinate).to_not be_valid

      coordinate.longitude = 190
      expect(blank_coordinate).to_not be_valid
    end
  end
end
