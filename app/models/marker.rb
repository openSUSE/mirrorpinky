class Marker < ActiveRecord::Base
  set_table_name 'marker'
  attr_accessible :subtree_name, :markers
end
