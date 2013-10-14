require 'extract_informations_from_host'
class Admin::ServersController < ApplicationController
  before_filter :require_valid_user
  before_filter :load_group
  before_filter :load_server, only: [:show, :edit, :destroy, :update]
  # GET /servers
  # GET /servers.json
  def index
    redirect_to admin_root_path
    # @servers = current_user.servers.all

    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.json { render :json => @servers }
    # end
  end

  # GET /servers/1
  # GET /servers/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @server }
    end
  end

  # GET /servers/new
  # GET /servers/new.json
  def new
    @server = Server.new
    @server.score = 100

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @server }
    end
  end

  # GET /servers/1/edit
  def edit
  end

  # POST /servers
  # POST /servers.json
  def create
    # please set all the values here that we dont allow editing but where the DB requires it as non null
    options_default = {
      scan_fpm: 0,
      score: 100,
      comment: '',
      public_notes: '',
      other_countries: '',
      status_baseurl: true,
      #
    }
    e = ExtractInformations.new(params[:server][:baseurl])
    error_out_on_multiple_ips(e, :ipv4)
    error_out_on_multiple_ips(e, :ipv6)

    e.results[:ipv4_addresses].each do |ip_address, data|
      if e.results[:ipv4_addresses][ip_address][:asn] and e.results[:ipv4_addresses][ip_address][:asn].number and e.results[:ipv4_addresses][ip_address][:asn_from_db] and e.results[:ipv4_addresses][ip_address][:asn_from_db]
        if e.results[:ipv4_addresses][ip_address][:asn].number != "AS#{e.results[:ipv4_addresses][ip_address][:asn_from_db].asn}"
          Rails.logger.warning "Got different AS from DB (#{e.results[:ipv4_addresses][ip_address][:asn].number}) and GeoIP (#{e.results[:ipv4_addresses][ip_address][:asn_from_db].asn})"
        end
      end
      if data[:city]
        options_default[:region]  ||= Region.where(code:  data[:city].continent_code.downcase).first
        options_default[:country] ||= Country.where(code: data[:city].country_code2.downcase).first
        options_default[:lat]     ||= data[:city].latitude
        options_default[:lng]     ||= data[:city].longitude
      end
      if data[:asn_from_db]
        options_default[:asnprefix] ||= data[:asn_from_db]
        options_default[:prefix]    ||= data[:asn_from_db].pfx
      end
    end
    server_params = options_default.merge(params[:server])
    @server = @group.servers.new(server_params)
    Rails.logger.debug @server

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


    respond_to do |format|
      if @server.save
        @group.servers << @server
        format.html { redirect_to admin_group_server_url(@group,@server), :notice => 'Server was successfully created.' }
        format.json { render :json => @server, :status => :created, :location => @server }
      else
        format.html { render :action => "new" }
        format.json { render :json => @server.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /servers/1
  # PUT /servers/1.json
  def update
    respond_to do |format|
      if @server.update_attributes(params[:server])
        format.html { redirect_to admin_group_server_url(@group, @server), :notice => 'Server was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @server.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /servers/1
  # DELETE /servers/1.json
  def destroy
    @server.destroy

    respond_to do |format|
      format.html { redirect_to admin_group_servers_url }
      format.json { head :no_content }
    end
  end

  private
  def load_server
    @server = current_user.servers.find(params[:id])
  end
  def load_group
    @group  = current_user.groups.where(id: params[:group_id]).first
  end

  def error_out_on_multiple_ips(e, ip_type)
    hash_index = "#{ip_type}_addresses".to_sym
    if e.results[hash_index].length > 1
      Rails.logger.error("Server resolves to more than one #{ip_type} address #{e.results[hash_index].keys}")
      format.html { render :action => "new", error: "Your server resolves to multiple #{ip_type} address for the same host. This can cause problems. Please see http://mirrorbrain.org/archive/mirrorbrain/0042.html ." }
      format.json { render :json => @server.errors, :status => :unprocessable_entity }
    end
  end
end
