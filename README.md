# Latitude

[![Build
Status](https://travis-ci.org/umtrey/latitude-gem.svg?branch=master)](https://travis-ci.org/umtrey/latitude-gem)

Latitude is a simple gem for calculating distances and headings between two
geographic locations, using great circle math.

For now, this gem uses the WGS84 measurements for the shape of the
earth.

## Installation

Add this line to your application's Gemfile:

    gem 'latitude'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install latitude

## Usage

Note that coordinates are positive for N/E and negative for S/W.

### Using Coordinate objects

A `Coordinate` takes in a `:latitude` and `:longitude` in either decimal
or DMS format. For example,

```
coordinate = Coordinate.new(:latitude => "10 S",
                            :longitude => "9° 30′ E")
coordinate.latitdue     #=> -10.0
coordinate.longitude    #=> 9.5
```

`Coordinate`s have multiple helper methods:

`#great_circle_distance_to(final_coordinate)` calculates the great
circle distance between coordinates.

`#initial_bearing_to(final_coordinate)` calculates the initial bearing
if traveling along a great circle route to another coordinate.

`#final_bearing_to(initial_coordinate)` calculates the final bearing if
traveling along a great circle route from another coordinate.

### Without Coordinate objects

```
Latitude.great_circle_distance(start_latitude, start_longitude, end_latitude,
end_longitude)
```

Calculates the great circle distance in kilometers between two
coordinates.

```
Latitude.initial_heading(start_latitude, start_longitude, end_latitude, end_longitude)
Latitude.final_heading(start_latitude, start_longitude, end_latitude, end_longitude)
```

Calculates the initial and final headings if traveling between two
points using a great circle path.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/latitude/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
