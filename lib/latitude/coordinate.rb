class Coordinate
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

private
  def convert_degree_input_to_decimal(input, valid_directions, negative_directions)
    return unless input
    begin
      return Float(input)
    rescue
      input.strip!
      numerical_part = input[0...-1]
      cardinal_direction = input[-1].upcase
      raise ArgumentError unless valid_directions.map(&:upcase).include? cardinal_direction

      if negative_directions.map(&:upcase).include? cardinal_direction
        return -1 * Float(numerical_part)
      else
        return Float(numerical_part)
      end
    end
  end
end
