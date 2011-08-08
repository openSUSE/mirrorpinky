require 'tzinfo'
class Server < ActiveRecord::Base
  set_table_name 'server'
  has_one :country, :primary_key => :country, :foreign_key => :code
  has_one :region,  :primary_key => :region,  :foreign_key => :code
  has_many :files,  :class_name => 'MirrorFile', :finder_sql => proc { "SELECT * FROM filearr where #{id} = any(mirrors)" }

  def starcount
    case score
      when 0..49: 1
      when 50..99: 2
      else 3
    end
  end

  def has_marked_file?(path)
    @@markers ||= Marker.all.map(&:markers)
    @marked_files ||= MirrorFile.where("? = any(mirrors)", id).where(:path => @@markers).select(:path).map(&:path)
    @marked_files.include? path
  end
end
