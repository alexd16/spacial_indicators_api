class Indicator::NNDistanceCumulativeDistribution

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
    {result: cumulative_distribution(points, indexed_points, kdtree),type: 'long_value_collection'}
  end

  def cumulative_distribution(points, indexed_points, kdtree)
    distances = points.map do |point|
      id = kdtree.nearestk(point.x, point.y, 2)[1]
      nearest_point = indexed_points[id]
      distance = point.haversine_distance_to(nearest_point)
      if(config['growth'] == 'Logaritmic')
        distance.to_f**(1/3.0)
      elsif(config['growth'] == 'Exponencial')
        distance.to_f**3
      else
        distance.to_f
      end
    end
    distances = distances.sort_by {|dist| -dist}
    distances = distances.map {|dist| dist/distances.reduce(:+)}
    distances = distances.each_with_index.map do |distance, index|
      sum = distances[index..distances.size-1].reduce(:+)
      [index, sum]
    end
    
    distances
  end

end