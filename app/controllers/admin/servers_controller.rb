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
    @server = @group.servers.new(params[:server])

    Rails.logger.debug @server.inspect
    respond_to do |format|
      if @server.save
        format.html { redirect_to @server, :notice => 'Server was successfully created.' }
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
        format.html { redirect_to @server, :notice => 'Server was successfully updated.' }
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
      format.html { redirect_to servers_url }
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
