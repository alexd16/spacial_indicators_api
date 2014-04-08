class Context
  include Mongoid::Document

  field :name, type: String
  field :tags, type: Array
  field :boundingBox, type: Hash 
  field :sliceBounds, type: Hash 
  field :context_indicators, type: Array 
  field :zoomLevel
  field :pointsDrawn
  field :numberOfObjects
  field :note

  belongs_to :dataset

  def bounding_box 
    Spacial::Box.from_hash(boundingBox) if boundingBox
  end

  def slice_box
    Spacial::Box.from_hash(sliceBounds) if sliceBounds && !sliceBounds.empty?
  end

  def data
    data = dataset.data(slice_box.try(:query_predicate))
    format_data(data)
  end

  def compute_indicators
    context_indicators.each do |context_indicator|
      klass = INDICATORS_CLASS[context_indicator['name']]
      indicator = klass.new(self, context_indicator)
      context_indicator['result'] = indicator.compute
    end
    save
  end

  INDICATORS_CLASS = {
    "NNI" => Indicator::NNI,
    "Grid Cell Frequency" => Indicator::GridCellFrequency
  } 

  private

  def format_data(data)
    data.map do |tuple|
      Spacial::Point.new(tuple["longitude"].to_f, tuple["latitude"].to_f)
    end
  end
end
