class MirrorFileHash < ActiveRecord::Base
  self.table_name = 'hash'
  belongs_to :file, :class_name => 'MirrorFile'
end
