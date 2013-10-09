class Country < ActiveRecord::Base
  self.table_name = 'country'
  has_many :servers, :primary_key => :code, :foreign_key => :country
end
