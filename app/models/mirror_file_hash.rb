class MirrorFileHash < ActiveRecord::Base
  set_table_name 'hash'
  belongs_to :file, :class_name => 'MirrorFile'
end
