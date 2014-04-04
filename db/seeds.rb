# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Indicator.create(
  name: 'NNI', 
  klass_name: 'Indicator::NNI',
  params: [
    {name: 'influence', type: 'multiple_options_list', options: ['None', 'Low', 'Medium', 'High'], default: ['None']}
  ]
)


Indicator.create(
  name: 'Grid Cell Frequency',
  klass_name: 'Indicator::GridCellFrequency',
  params: [
  ]
)