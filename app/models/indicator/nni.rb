class Indicator::NNI
  attr_reader :context, :context_indicator, :config

  def initialize(context, context_indicator)
    @context = context
    @context_indicator = context_indicator
    @config = context_indicator['config']
  end

  def compute
    indexed_points = {}
    tree_data = []
    points = context.data
    context.data.each_with_index do |point, index| 
      indexed_points[index] = point
      tree_data << [point.x, point.y, index]
    end
    kdtree = Kdtree.new(tree_data)
    result = influence_values.map {|key, value| [key, nni(points, value, indexed_points, kdtree)]}
    if result.size == 1 
      {result: result[0][1], type: 'single_value'}
    else
      result.sort! {|val1, val2| INFLUENCE_POSITION[val1[0]] <=> INFLUENCE_POSITION[val2[0]]}
      {result: result, type: 'value_collection'}
    end
  end

  def nni(points, influence, indexed_points, kdtree)
    n = points.size
    area = context.bounding_box.area
    sum_distances = points.map do |point|
      id = kdtree.nearestk(point.x, point.y, 2)[1]
      nearest_point = indexed_points[id]
      distance(point, nearest_point, influence)
    end
    avg_distances = sum_distances.reduce(:+)/n
    #binding.pry
    (2 * avg_distances) * Math::sqrt(n / area) 
  end

  def influence_values
    config["influence"].map do |value| 
      width = context.bounding_box.diagonal
      influence = width * (INFLUENCE_MAPPING[value])
      #binding.pry
      [value, influence] 
    end
  end

  def distance(p1,p2, influence = 0)
    #bl = context.bounding_box.bl
    #p1_mercator = p1.to_mercator(bl)
    #p2_mercator = p2.to_mercator(bl)
    #p1_mercator = Spacial::Point.new(p1_mercator.x - bl_mercator.x, p1_mercator.y - bl_mercator.y)
    #p2_mercator = Spacial::Point.new(p2_mercator.x - bl_mercator.x, p2_mercator.y - bl_mercator.y)
    #distance = p1_mercator.linear_distance_to(p2_mercator) - influence
    #binding.pry
    #distance >= 0 ? distance : 0
    distance = p1.haversine_distance_to(p2) - influence
    distance >= 0 ? distance : 0
  end

  private

  INFLUENCE_MAPPING = {
    'None' => 0,
    'Low' => 0.1/100,
    'Medium' => 0.5/100,
    'High' => 1/100.0
  }

  INFLUENCE_POSITION = {
    'None' => 1,
    'Low' => 2,
    'Medium' => 3,
    'High' => 4 
  }
  
end