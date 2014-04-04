class Dataset
  include Mongoid::Document

  field :name, type: String
  field :columns, type: Array 

  has_many :contexts

  after_create :create_table
  after_destroy :destroy_table

  def insert_data(data)
    batch_insert(data)
  end

  def data(predicate = nil)
    query = "select * from #{name} "
    query << "where ST_Within(ST_PointFromText('POINT(' || longitude || ' ' || latitude || ')',4326),#{predicate})" if predicate
    ActiveRecord::Base.connection.execute(query)
  end

  private 

  def create_table
    ActiveRecord::Base.connection.execute(%{
      DROP TABLE IF EXISTS #{name};
      create table #{name} (
        id bigserial primary key,
        latitude decimal(9,6),
        longitude decimal(9,6)
      )
    })
  end

  def destroy_table
    ActiveRecord::Base.connection.execute(%(
      DROP TABLE IF EXISTS #{name};
    ))
  end

  def batch_insert(data)
    tuples = data.map {|tuple| "(#{tuple[:latitude]}, #{tuple[:longitude]})"}.join(",\n")
    ActiveRecord::Base.connection.execute(%{
      insert into #{name} (latitude, longitude) values #{tuples}
    })
  end
end
