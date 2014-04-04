class Indicator
  include Mongoid::Document

  field :name, type: String
  field :klass_name, type: String
  field :params, type: Array

  
end
