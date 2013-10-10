require 'tzinfo'
require 'rfc822'

class Server < ActiveRecord::Base
  self.table_name = 'server'
  has_and_belongs_to_many :group

  has_one :country, primary_key: :country, foreign_key: :code
  has_one :region,  primary_key: :region,  foreign_key: :code
  has_many :files,  class_name: 'MirrorFile', finder_sql: proc { "SELECT * FROM filearr where #{id} = any(mirrors)" }
  validates :other_countries, format: { with: /\A([a-z0-9]{2}([, ][a-z0-9]{2})*)?\Z/ }
  validates :baseurl,         format: { with: URI::regexp(%w(http https)) }
  validates :baseurl_ftp,     format: { with: URI::regexp(%w(ftp))        }, allow_blank: true
  validates :baseurl_rsync,   format: { with: URI::regexp(%w(rsync))      }, allow_blank: true
  validates :operator_url,    format: { with: URI::regexp(%w(http https)) }, allow_blank: true
  validates :asn,             numericality: { only_integer: true }
  validates :score,           numericality: { only_integer: true }, inclusion: 1..150
  validates :identifier,      presence: true# , uniqueness: true
  validates :admin_email,     format: { with: RFC822::EMAIL_REGEXP_WHOLE }
  validates :file_maxsize,    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  attr_accessible :admin, :admin_email, :as_only, :asn, :baseurl, :baseurl_ftp,
    :baseurl_rsync, :comment, :country, :country_only, :enabled, :file_maxsize,
    :id, :identifier, :last_scan, :lat, :lng, :operator_name, :operator_url,
    :other_countries, :prefix, :prefix_only, :public_notes, :region,
    :region_only, :scan_fpm, :score, :status_baseurl

# TODO: check if we need validators for those
#   file_maxsize: 0
#   public_notes: ""
#   comment: |-

  def starcount
    # case score
    #   when (0..49): 1
    #   when (50..99): 2
    #   else 3
    # end
    3
  end

  def has_marked_file?(path)
    @@markers ||= Marker.all.map(&:markers)
    @marked_files ||= MirrorFile.where("? = any(mirrors)", id).where(path: @@markers).select(:path).map(&:path)
    @marked_files.include? path
  end
end
