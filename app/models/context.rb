class Context
  include Mongoid::Document

  field :name, type: String
  field :tags, type: Array
  field :boundingBox, type: Hash 
  field :sliceBounds, type: Hash 
  #field :context_indicators, type: Array 
  field :zoomLevel
  field :pointsDrawn
  field :numberOfObjects
  field :notes

  belongs_to :dataset

  has_many :context_indicators, autosave: true
  accepts_nested_attributes_for :context_indicators, autosave: true

  def bounding_box 
    Spacial::Box.from_hash(boundingBox) if boundingBox
  end

  def slice_box
    Spacial::Box.from_hash(sliceBounds) if sliceBounds && !sliceBounds.empty?
  end

  def original_data
    data = dataset.data
    format_data(data)
  end

  def data
    data = dataset.data(slice_box.try(:query_predicate))
    format_data(data)
  end

  def compute_indicators
    context_indicators.each do |context_indicator|
      klass = context_indicator.klass_name.constantize
      indicator = klass.new(self, context_indicator)
      context_indicator.result = indicator.compute
      context_indicator.save
    end
    save
  end

  INDICATORS_CLASS = {
    "NNI" => Indicator::NNI,
    "Grid Cell Frequency" => Indicator::GridCellFrequency,
    'Grid Cell Frequency Distribution' => Indicator::GridCellFrequencyDistribution,
    'Nearest Neighbour Distance Cumulative Distribution' => Indicator::NNDistanceCumulativeDistribution
  } 

  private

  def format_data(data)
    data.map do |tuple|
      Spacial::Point.new(tuple["longitude"].to_f, tuple["latitude"].to_f)
    end
  end
end
