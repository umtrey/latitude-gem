require "latitude/version"

module Latitude
  extend self
  def great_circle_distance(start_latitude, start_longitude, end_latitude, end_longitude)
    return 0 if (start_latitude == end_latitude) && (start_longitude == end_longitude)
  end
end
