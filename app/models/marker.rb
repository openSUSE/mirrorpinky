class Marker < ActiveRecord::Base
  self.table_name = 'marker'
  attr_accessible :subtree_name, :markers
end
