class Spacial::Point
  MERCATOR_PROJECTION = Proj4::Projection.new("+proj=merc +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=6378137 +b=6378137 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
  EARTH_RADIUS = 6371
  
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def self.from_coords_hash(hash)
    x = hash["longitude"]
    y = hash["latitude"]
    new(x,y)
  end

  def to_rad
    Spacial::Point.new(x.to_rad, y.to_rad)
  end

  def to_mercator(origin = nil) 
    p = MERCATOR_PROJECTION.forward(to_rad)
    if origin
      origin_mercator = origin.to_mercator
      Spacial::Point.new(p.x - origin_mercator.x, p.y - origin_mercator.y)
    else
      Spacial::Point.new(p.x, p.y)
    end
  end

  def linear_distance_to(destination)
    Math::sqrt(((x - destination.x)**2 + (y - destination.y)**2))
  end

  # Point must be a gps coordinate
  def haversine_distance_to(destination)
    delta_latitude = ((destination.y - y) * Math::PI)/180
    delta_longitude = ((destination.x - x) * Math::PI)/180
    origin_lat_rad = (y * Math::PI)/180
    destination_lat_rad = (destination.y * Math::PI)/180
    a = Math::sin(delta_latitude/2) * Math::sin(delta_latitude/2) + 
      (Math::sin(delta_longitude/2)* 
      Math::sin(delta_longitude/2) * 
      Math::cos(origin_lat_rad) * 
      Math::cos(destination_lat_rad)
      )
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
    EARTH_RADIUS * c
  end
end