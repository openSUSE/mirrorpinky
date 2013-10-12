class Region < ActiveRecord::Base
  self.table_name = 'region'
  self.primary_key = 'code'
  has_many :servers, :primary_key => :code, :foreign_key => :region
end
