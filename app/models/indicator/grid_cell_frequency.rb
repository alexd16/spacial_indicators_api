class Indicator::GridCellFrequency

  attr_reader :context, :context_indicator, :config
  def initialize(context, context_indicator)
    @context = context
    @context_indicator = context_indicator
    @config = context_indicator['config']
  end

  def compute
    matrix = Array.new(number_horizontal_cells + 1) { Array.new(number_vertical_cells + 1,0 ) }
    points = context.data
    result = grid_cell_frequency(matrix, points)
    type = 'pair_collection'
    {result: result, type: type}
  end

  def grid_cell_frequency(matrix, points)
    bl = context.bounding_box.bl
    points.each do |point|
      x_width = point.x - bl.x
      y_height = point.y - bl.y
      x = (x_width / cell_width).to_i
      y = (y_height / cell_width).to_i
      matrix[x][y] += 1
    end
    formated_matrix = matrix.each_with_index.map do |row, x|
      row.each_with_index.map do |cell_count, y|
        if(config['growth'] == 'Logaritmic')
          {x: x, y: y, size: Math.log(cell_count)}
        elsif(config['growth'] == 'Exponencial')
          {x: x, y: y, size: Math.exp(cell_count)}
        else
          {x: x, y: y, size: cell_count}
        end
      end
    end
    formated_matrix.flatten
  end

  def cell_percentage
    @config['grid_cell_fraction'].to_f 
  end

  def number_horizontal_cells
    (max_width / cell_width).ceil
  end

  def number_vertical_cells
    (max_height / cell_width).ceil
  end

  def cell_width
    max_width * (cell_percentage/100.0)
  end

  def max_width
    bounding_box = context.bounding_box
    bounding_box.tr.x - bounding_box.bl.x
  end

  def max_height
    bounding_box = context.bounding_box
    bounding_box.tr.y - bounding_box.bl.y
  end
end