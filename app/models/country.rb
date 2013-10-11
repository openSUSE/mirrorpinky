class Country < ActiveRecord::Base
  self.table_name = 'country'
  self.primary_key = 'code'
  has_many :servers, :primary_key => :code, :foreign_key => :country
end
