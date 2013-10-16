require 'tzinfo'
require 'rfc822'
require 'extract_informations_from_host'

class Server < ActiveRecord::Base
  self.table_name = 'server'
  has_and_belongs_to_many :group

  before_validation :set_defaults, on: :create
  before_validation :extract_informations, on: [:create,:update]

  belongs_to :country, foreign_key: :country
  belongs_to :region,  foreign_key: :region
  belongs_to :asnprefix,  primary_key: :asn, foreign_key: :asn
  has_many :files,  class_name: 'MirrorFile', finder_sql: proc { "SELECT * FROM filearr where #{id} = any(mirrors)" }
  has_many :rsync_acls
  has_many :rsync_acl_request

  validates :other_countries, format: { with: /\A([a-z0-9]{2}([, ][a-z0-9]{2})*)?\Z/ }, allow_blank: true
  validates :baseurl,         format: { with: URI::regexp(%w(http https)) }
  validates :baseurl_ftp,     format: { with: URI::regexp(%w(ftp))        }, allow_blank: true
  validates :baseurl_rsync,   format: { with: URI::regexp(%w(rsync))      }, allow_blank: true
  validates :operator_url,    format: { with: URI::regexp(%w(http https)) }, allow_blank: true
  validates :asn,             numericality: { only_integer: true }
  validates :score,           numericality: { only_integer: true }, inclusion: 1..150, presence: true
  validates :identifier,      presence: true, uniqueness: true
  validates :admin_email,     format: { with: RFC822::EMAIL_REGEXP_WHOLE }
  validates :file_maxsize,    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :scan_fpm,        numericality: { only_integer: true }, presence: true
  validates :comment,         presence: true, allow_blank: true
  validates :public_notes,    presence: true, allow_blank: true
  validates :other_countries, presence: true, allow_blank: true
  validates :status_baseurl,  presence: true
  # attr_accessible :admin, :admin_email, :as_only, :asn, :asnprefix,  :baseurl, :baseurl_ftp,
  #   :baseurl_rsync, :comment, :country, :country_only, :enabled, :file_maxsize,
  #   :id, :identifier, :last_scan, :lat, :lng, :operator_name, :operator_url,
  #   :other_countries, :prefix, :prefix_only, :public_notes, :region,
  #   :region_only, :scan_fpm, :score, :status_baseurl

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
    @@marked_files ||= MirrorFile.where("? = any(mirrors)", id).where(path: @@markers).select(:path).map(&:path)
    @@marked_files.include? path
  end

  private
  def set_defaults
    self.scan_fpm=0
    self.score=100
    self.comment=''
    self.public_notes=''
    self.other_countries=''
    self.status_baseurl=true
  end

  def extract_informations
# #<ExtractInformations:0x0000000463ab60
#  @results=
#   {:ipv4_addresses=>
#     {"62.146.92.202"=>
#       {:asn_from_db=>#<Asnprefix pfx: "62.146.0.0/16", asn: 15598>,
#        :asn=>
#         #<struct GeoIP::ASN
#          number="AS15598",
#          asn="QSC AG / ehem. IP Exchange GmbH">,
#        :city=>
#         #<struct GeoIP::City
#          request="62.146.92.202",
#          ip="62.146.92.202",
#          country_code2="DE",
#          country_code3="DEU",
#          country_name="Germany",
#          continent_code="EU",
#          region_name="",
#          city_name="",
#          postal_code="",
#          latitude=51.0,
#          longitude=9.0,
#          dma_code=nil,
#          area_code=nil,
#          timezone="Europe/Berlin",
#          real_region_name=nil>}},
#    :ipv6_addresses=>
#     {"2A01:138:A004::21A:A0FF:FE26:EFA9"=>
#       {:city=>
#         #<struct GeoIP::City
#          request="2A01:138:A004::21A:A0FF:FE26:EFA9",
#          ip="2a01:138:a004:0:21a:a0ff:fe26:efa9",
#          country_code2="DE",
#          country_code3="DEU",
#          country_name="Germany",
#          continent_code="EU",
#          region_name="",
#          city_name="",
#          postal_code="",
#          latitude=51.0,
#          longitude=9.0,
#          dma_code=nil,
#          area_code=nil,
#          timezone="Europe/Berlin",
#          real_region_name=nil>}}}>
    begin
      e = ExtractInformations.new(self.baseurl)
    rescue ArgumentError => ex
      errors.add(:baseurl, ex.message)
    end
    if e
      error_out_on_multiple_ips(e, :ipv4)
      error_out_on_multiple_ips(e, :ipv6)

      e.results[:ipv4_addresses].each do |ip_address, data|
        if e.results[:ipv4_addresses][ip_address][:asn] and e.results[:ipv4_addresses][ip_address][:asn].number and e.results[:ipv4_addresses][ip_address][:asn_from_db] and e.results[:ipv4_addresses][ip_address][:asn_from_db]
          if e.results[:ipv4_addresses][ip_address][:asn].number != "AS#{e.results[:ipv4_addresses][ip_address][:asn_from_db].asn}"
            Rails.logger.warning "Got different AS from DB (#{e.results[:ipv4_addresses][ip_address][:asn].number}) and GeoIP (#{e.results[:ipv4_addresses][ip_address][:asn_from_db].asn})"
          end
        end
        if data[:city]
          self.region  = Region.where(code:  data[:city].continent_code.downcase).first
          self.country = Country.where(code: data[:city].country_code2.downcase).first
          self.lat     = data[:city].latitude
          self.lng     = data[:city].longitude
        end
        if data[:asn_from_db]
          self.asnprefix = data[:asn_from_db]
          self.prefix    = data[:asn_from_db].pfx
        end
      end
      if e.results[:ipv4_addresses].empty? and !e.results[:ipv6_addresses].empty?
        self.ipv6_only = true
      end
    end
  end

  def error_out_on_multiple_ips(e, ip_type)
    hash_index = "#{ip_type}_addresses".to_sym
    if e.results[hash_index].length > 1
      errors.add(:baseurl, "Your server resolves to multiple #{ip_type} address for the same host. This can cause problems. Please see http://mirrorbrain.org/archive/mirrorbrain/0042.html .")
    end
  end

end
