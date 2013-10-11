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
      # TODO: grab from http base url
      asn: 1,
      region: Region.first,
      country: Country.first,
      prefix: '127.0.0.0/8',
      #
    }
    server_params = options_default.merge(params[:server])
    @server = @group.servers.new(server_params)
    Rails.logger.debug @server.inspect
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
end
