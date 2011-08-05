require 'tzinfo'
class Server < ActiveRecord::Base
  set_table_name 'server'
  has_one :country, :primary_key => :country, :foreign_key => :code
  has_one :region,  :primary_key => :region,  :foreign_key => :code

  def starcount
    case score
      when 0..49: 1
      when 50..99: 2
      else 3
    end
  end
end
