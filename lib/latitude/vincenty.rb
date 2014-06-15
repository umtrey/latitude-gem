# thanks to http://www.movable-type.co.uk/scripts/latlong-vincenty.html

module Vincenty
  extend self

  # in meters
  WGS84_A = 6378137
  WGS84_B = 6356752.314245
  WGS84_F = 1 / 298.257223563

  def great_circle_distance(start_lat, start_long, end_lat, end_long)
    return 0 if (start_lat == end_lat) && (start_long == end_long)

    solution_set(start_lat, start_long, end_lat, end_long)[:distance]
  end

  def initial_bearing(start_lat, start_long, end_lat, end_long)
    return nil if (start_lat == end_lat) && (start_long == end_long)

    solution_set(start_lat, start_long, end_lat, end_long)[:initial_bearing]
  end

  def final_bearing(start_lat, start_long, end_lat, end_long)
    return nil if (start_lat == end_lat) && (start_long == end_long)

    solution_set(start_lat, start_long, end_lat, end_long)[:final_bearing]
  end

private
  def solution_set(start_lat, start_long, end_lat, end_long)
    a = WGS84_A
    b = WGS84_B
    f = WGS84_F

    phi_1 = to_radians(start_lat)
    lambda_1 = to_radians(start_long)
    phi_2 = to_radians(end_lat)
    lambda_2 = to_radians(end_long)

    iterative_solver(phi_1, lambda_1,
                     phi_2, lambda_2,
                     a, b, f)
  end

  def iterative_solver(phi_1, lambda_1, phi_2, lambda_2, a, b, f)
    l = lambda_2 - lambda_1
    sin_u1, cos_u1 = get_trig_trio(phi_1, f)
    sin_u2, cos_u2 = get_trig_trio(phi_2, f)

    lam = l
    iterations = 0

    begin
      sin_lam = Math.sin(lam)
      cos_lam = Math.cos(lam)

      sin_sigma = Math.sqrt((cos_u2 * sin_lam)**2 + ((cos_u1 * sin_u2) - (sin_u1 * cos_u2 * cos_lam))**2)
      return 0 if sin_sigma == 0 # co-incident points

      cos_sigma = (sin_u1 * sin_u2) + (cos_u1 * cos_u2 * cos_lam)
      sigma = Math.atan2(sin_sigma, cos_sigma)

      sin_alpha = cos_u1 * cos_u2 * sin_lam / sin_sigma
      cos_sq_alpha = 1 - sin_alpha**2

      if cos_sq_alpha == 0
        cos_2sigma_m = 0
      else
        cos_2sigma_m = cos_sigma - 2 * sin_u1 * sin_u2 / cos_sq_alpha
      end

      c = f/16 * cos_sq_alpha * (4 + f*(4 - 3*cos_sq_alpha))
      lam_prime = lam
      lam = l + (1 - c) * f * sin_alpha *
              (sigma + c * sin_sigma * (cos_2sigma_m + c * cos_sigma * (-1 + 2 * cos_2sigma_m**2)))
    end while ((lam - lam_prime).abs >= 1e-12) && ((iterations += 1) < 100)

    raise Exception("Failed to converge") if iterations >= 100

    u_sq = cos_sq_alpha * (a**2 - b**2) / (b**2)
    big_a = 1 + u_sq/16384 * (4096 + u_sq * (-768 + u_sq * (320 - 175 * u_sq)))
    big_b = u_sq/1024 * (256 + u_sq * (-128 + u_sq * (74-47 * u_sq)))
    delta_sigma = big_b * sin_sigma * (cos_2sigma_m + big_b/4 * (cos_sigma * (-1 + 2*(cos_2sigma_m**2)) -
                    big_b/6 * cos_2sigma_m * (-3 + 4*(sin_sigma**2)) * (-3 + 4*(cos_sigma**2))))

    distance = (b * big_a * (sigma - delta_sigma)).round(3) # 1mm precision
    fwd_az = Math.atan2(cos_u2 * sin_lam, (cos_u1 * sin_u2) - (sin_u1 * cos_u2 * cos_lam))
    rev_az = Math.atan2(cos_u1 * sin_lam, (cos_u1 * sin_u2 * cos_lam) - (sin_u1 * cos_u2))

    # var fwdAz = Math.atan2(cosU2*sinλ,  cosU1*sinU2-sinU1*cosU2*cosλ);
    # var revAz = Math.atan2(cosU1*sinλ, -sinU1*cosU2+cosU1*sinU2*cosλ);
    # return { distance: s, initialBearing: fwdAz.toDegrees(), finalBearing: revAz.toDegrees() };
    { :distance => distance,
      :initial_bearing => to_degrees(fwd_az),
      :final_bearing => to_degrees(rev_az) }
  end

  def to_radians(degrees)
    degrees * Math::PI / 180
  end

  def to_degrees(rads)
    rads * 180 / Math::PI
  end

  def get_trig_trio(rads, f)
    tan = (1-f) * Math.tan(rads)
    cos = 1 / Math.sqrt(1 + tan**2)
    sin = tan * cos
    [sin, cos, tan]
  end
end
