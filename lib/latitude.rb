require "latitude/version"
require "latitude/vincenty"

module Latitude
  extend self
  def great_circle_distance(start_latitude, start_longitude, end_latitude, end_longitude)
    # in kilometers
    m_distance = Vincenty.great_circle_distance(start_latitude, start_longitude,
                                                end_latitude, end_longitude)

    return m_distance / 1000.0
  end

end
