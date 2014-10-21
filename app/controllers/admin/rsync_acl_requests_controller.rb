class Admin::RsyncAclRequestsController < ApplicationController
  load_and_authorize_resource :group
  load_and_authorize_resource :server, :through => :group

  # GET /admin/rsync_acls
  def index
    @rsync_acl_requests = RsyncAclRequest.all
    authorize! :admin, @rsync_acl_requests
  end

  # GET /admin/rsync_acls/1
  def show
    # we dont need more than the listing provided by index
  end

  # GET /admin/rsync_acls/new
  def new
    authorize! :rsync_acl_request, :new
    @rsync_acl_request = RsyncAclRequest.new
  end

  # GET /admin/rsync_acls/1/edit
  def edit
    @rsync_acl_request = RsyncAclRequest.include(:server).find(params.require(:id)[:id])
    authorize! :admin, @rsync_acl_request
  end

  # POST /admin/rsync_acls
  def create
    authorize! :rsync_acl_request, :create
    @rsync_acl_request = @server.rsync_acl_requests.build(admin_rsync_acl_params)
    @rsync_acl_request.server = @server
    # authorize! :admin, @rsync_acl_request
    if @rsync_acl_request.save
      redirect_to admin_group_server_url(@server.group.first, @server), notice: 'rsync ACL request was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /admin/rsync_acls/1
  def update
    @rsync_acl_request = RsyncAclRequest.include(:server).find(params.require(:id))
    authorize! :admin, @rsync_acl_request
    if @rsync_acl_request.update(admin_rsync_acl_params)
      redirect_to admin_rsync_acl_requests, notice: 'rsync ACL request was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /admin/rsync_acls/1
  def destroy
    authorize! :rsync_acl_request, :destroy
    @rsync_acl_request = RsyncAclRequest.find(params.require(:id))
    @server = @rsync_acl_request.server
    authorize! :admin, @server
    @group = @server.group.first
    authorize! :admin, @server
    # TODO: authorize! :admin, @rsync_acl_request
    @rsync_acl_request.destroy
    redirect_url = admin_group_server_url(@group, @server)
    redirect_to redirect_url, notice: 'rsync ACL request was successfully revoked.'
  end

  def approve
    authorize! :rsync_acl_request, :approve
    @rsync_acl_request = RsyncAclRequest.find(params.require(:id))
    rsync_acl = RsyncAcl.new(host: @rsync_acl_request.host, server: @rsync_acl_request.server)
    if rsync_acl.save
      @rsync_acl_request.delete
      redirect_to admin_rsync_acl_requests_path, notice: 'rsync ACL request was successfully created.'
    else
      redirect_to admin_rsync_acl_requests_path, notice: 'accepting the ACL request failed'
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def admin_rsync_acl_params
      params.require(:rsync_acl_request).permit([:host, :server_id])
    end
end
