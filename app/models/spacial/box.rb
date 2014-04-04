class Spacial::Box

  attr_reader :bl, :tr

  def initialize(bl, tr)
    @bl = bl
    @tr = tr
  end

  def self.from_hash(hash)
    bl_coords = hash["bottomLeft"]
    tr_coords = hash["topRight"]
    bl = Spacial::Point.from_coords_hash(bl_coords)
    tr = Spacial::Point.from_coords_hash(tr_coords)
    new(bl, tr)
  end

  def tl
    Spacial::Point.new(bl.x, tr.y)
  end

  def br
    Spacial::Point.new(tr.x, bl.y)
  end 

  def query_predicate
    %{
      ST_MakePolygon(
        ST_GeomFromText('LINESTRING(#{bl.x} #{bl.y},#{tl.x} #{tl.y},#{tr.x} #{tr.y},#{br.x} #{br.y},#{bl.x} #{bl.y})',4326)
      )
    }
  end

  def width
    bl.haversine_distance_to(br)
  end

  def height
    bl.haversine_distance_to(tl)
  end

  def area
    #mercator_width = bl.linear_distance_to(br)
    #mercator_height = bl.linear_distance_to(tl)
    #mercator_width * mercator_height
    #top_width + right_height + bottom_width + left_height
    #bottom_width * left_height
    real_width * real_height
  end

  def top_width
    tl.haversine_distance_to(tr)
  end

  def bottom_width
    bl.haversine_distance_to(br)
  end

  def left_height
    bl.haversine_distance_to(tl)
  end

  def right_height
    br.haversine_distance_to(tr)
  end


  def max_latitude
    tr.y
  end

  def min_latitude
    bl.y
  end

  def min_longitude
    bl.x
  end

  def max_longitude
    tr.x
  end

  def real_width
    if( (min_longitude < 0 && max_longitude > 0 ))
      middle = Spacial::Point.new(0, min_latitude)
      bl.haversine_distance_to(middle) + middle.haversine_distance_to(br)
    else
      bl.haversine_distance_to(br)
    end
  end

  def real_height
    if( (min_latitude < 0 && max_latitude > 0 ))
      middle = Spacial::Point.new(min_longitude, 0)
      bl.haversine_distance_to(middle) + middle.haversine_distance_to(tl)
    else
      bl.haversine_distance_to(tl)
    end
  end

end