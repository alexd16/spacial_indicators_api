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
    {name: 'growth', type: 'single_options_list', options: ['Logaritmic', 'Linear', 'Exponencial'], default: 'Linear'},
    {name: 'grid_cell_fraction', type: 'value', default: 10.00}
  ]
)

Indicator.create(
  name: 'Grid Cell Frequency Distribution',
  klass_name: 'Indicator::GridCellFrequencyDistribution',
  params: [
    {name: 'growth', type: 'single_options_list', options: ['Logaritmic', 'Linear', 'Exponencial'], default: 'Linear'},
    {name: 'grid_cell_fraction', type: 'value', default: 10.00}
  ]
)

Indicator.create(
  name: 'Nearest Neighbour Distance Cumulative Distribution',
  klass_name: 'Indicator::NNDistanceCumulativeDistribution',
  params: [
    {name: 'growth', type: 'single_options_list', options: ['Logaritmic', 'Linear', 'Exponencial'], default: 'Linear'}
  ]
)