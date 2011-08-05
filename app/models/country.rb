class Country < ActiveRecord::Base
  set_table_name 'country'
  has_many :servers, :primary_key => :code, :foreign_key => :country
end
