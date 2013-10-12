class MirrorFile < ActiveRecord::Base
  self.table_name = 'filearr'
  has_many :servers, :class_name => 'Server', :finder_sql => proc { "SELECT * from server where id in (#{mirrors.join(',')})" }
  # has_many :servers, :class_name => 'Server'
  # belongs_to :mirrors
  has_many :hashes,  :class_name => 'MirrorFileHash', :foreign_key => :file_id

end
