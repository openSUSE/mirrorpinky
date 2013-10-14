require 'uri'
require 'geoip'
require 'resolv'
require 'pry'

class ExtractInformations
  attr_reader :results
  def initialize(baseurl)
    # TODO: move this to some initializer, so it is initialized before we enter threaded stage
    @@geoip_asn_ipv4  = GeoIP.new('GeoIP/GeoIPASNum.dat.updated')
    @@geoip_asn_ipv6  = GeoIP.new('GeoIP/GeoIPASNumv6.dat.updated')
    @@geoip_city_ipv4 = GeoIP.new('GeoIP/GeoLiteCity.dat.updated')
    @@geoip_city_ipv6 = GeoIP.new('GeoIP/GeoLiteCityv6.dat.updated')

    uri = URI.parse(baseurl)
    @results = {}
    do_lookups(uri.host, results, :ipv4_addresses, Resolv::DNS::Resource::IN::A,    @@geoip_asn_ipv4, @@geoip_city_ipv4)
    do_lookups(uri.host, results, :ipv6_addresses, Resolv::DNS::Resource::IN::AAAA, @@geoip_asn_ipv6, @@geoip_city_ipv6)
  end

  private
  def do_lookups(hostname, results, ip_type, res_type, geoip_asn, geoip_city)
    Resolv::DNS.open do |dns|
      ress = dns.getresources hostname, res_type
      ress.each { |r|
        ip_address = r.address.to_s
        @results[ip_type] ||= {}
        @results[ip_type][ip_address] = {}
        # TODO: this can fail for ipv6
        if ip_type == :ipv4_addresses
          @results[ip_type][ip_address][:asn_from_db] = Asnprefix.by_ip(ip_address).first
        end
        begin
          @results[ip_type][ip_address][:asn]  = geoip_asn.asn(ip_address)
        rescue ArgumentError => ex
          # pass
        end
        begin
          @results[ip_type][ip_address][:city] = geoip_city.country(ip_address)
        rescue ArgumentError => ex
          # pass
        end

      }
    end
  end
end