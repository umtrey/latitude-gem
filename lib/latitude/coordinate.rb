#!/bin/env ruby
# encoding: utf-8

class Coordinate
  COORDINATE_CHARS = "0-9.\'\"°′″"
  attr_reader :latitude, :longitude

  def initialize(params = {})
    self.latitude  = params[:latitude]
    self.longitude = params[:longitude]
  end

  def latitude=(val)
    @latitude = convert_degree_input_to_decimal(val, ["N","S"], ["S"])
  end

  def longitude=(val)
    @longitude = convert_degree_input_to_decimal(val, ["E","W"], ["W"])
  end

  def valid?
    latitude && longitude && (latitude.abs <= 90) && (longitude.abs <= 180)
  end

  def great_circle_distance_to(final_coordinate)
    Vincenty.great_circle_distance(latitude, longitude,
                                   final_coordinate.latitude,
                                   final_coordinate.longitude)
  end

  def initial_bearing_to(final_coordinate)
    Vincenty.initial_bearing(latitude, longitude,
                             final_coordinate.latitude,
                             final_coordinate.longitude)
  end

  def final_bearing_from(start_coordinate)
    Vincenty.final_bearing(start_coordinate.latitude,
                           start_coordinate.longitude,
                           latitude, longitude)
  end

private
  def convert_degree_input_to_decimal(input, valid_directions, negative_directions)
    return if input.nil? || (input.is_a?(String) && input.empty?)
    input.strip! if input.is_a? String

    return Float(input) if is_number?(input)

    raise ArgumentError unless input.gsub(valid_char_regexp(valid_directions), "").empty?
    raise ArgumentError unless valid_end_char_regexp(valid_directions).match(input)

    if valid_directions.map(&:upcase).include? input[-1].upcase
      direction = input[-1].upcase
      convert_to_negative = negative_directions.map(&:upcase).include? direction
      input = input[0...-1].strip
    else
      convert_to_negative = false
    end

    return (convert_to_negative ? -1 : 1) * Float(input) if is_number?(input)

    degrees = minutes = seconds = 0
    # first, get the degrees
    if degree_location = input.index(/°/)
      degree_input = input[0...degree_location].strip
      input = input[degree_location+1..-1].strip
      degrees = Float(degree_input)
    end

    if minute_location = input.index(/[′\']/)
      minute_input = input[0...minute_location].strip
      input = input[minute_location+1..-1].strip
      minutes = Float(minute_input)
    end

    if second_location = input.index(/[″\"]/)
      second_input = input[0...second_location].strip
      input = input[second_location+1..-1].strip
      seconds = Float(second_input)
    end

    decimal_input = degrees + minutes/60 + seconds/3600

    return (convert_to_negative ? -1 : 1) * decimal_input
  end

  def is_number?(val)
    begin
      Float(val)
      return true
    rescue
      return false
    end
  end

  def basic_char_regexp
    Regexp.new("[" + COORDINATE_CHARS + "]")
  end

  def valid_char_regexp(additional_chars = [])
    Regexp.new("[" + COORDINATE_CHARS + additional_chars.join + ", ]")
  end

  def valid_end_char_regexp(additional_chars = [])
    Regexp.new("[" + COORDINATE_CHARS + additional_chars.join + "$]")
  end
end
