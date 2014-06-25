class ContextIndicator
  include Mongoid::Document

  field :name
  field :compute, type:Boolean
  field :config, type: Hash
  field :result, type: Hash

  delegate :klass_name, to: :indicator

  belongs_to :context
  belongs_to :indicator

  def compute
    
  end
end
