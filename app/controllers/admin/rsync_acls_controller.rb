class Admin::RsyncAclsController < ApplicationController
  load_and_authorize_resource :group
  load_and_authorize_resource :server, :through => :group
  load_and_authorize_resource :rsync_acl, :through => :server, only: [:show, :edit, :update, :destroy, :approve]
  # GET /admin/rsync_acls
  def index
    redirect_to admin_root_path
  end

  # GET /admin/rsync_acls/1
  def show
  end

  # GET /admin/rsync_acls/new
  def new
    @rsync_acl = RsyncAcl.new
  end

  # GET /admin/rsync_acls/1/edit
  def edit
  end

  # POST /admin/rsync_acls
  def create
    @rsync_acl = RsyncAcl.new(admin_rsync_acl_params)
    @rsync_acl.server = @server
    if @rsync_acl.save
      redirect_to admin_group_server_url(@group, @server), notice: 'Rsync acl was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /admin/rsync_acls/1
  def update
    if @rsync_acl.update(admin_rsync_acl_params)
      redirect_to admin_group_server_url(@group, @server), notice: 'Rsync acl was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /admin/rsync_acls/1
  def destroy
    @rsync_acl.destroy
    redirect_to admin_group_server_url(@group, @server), notice: 'Rsync acl was successfully deleted.'
  end

  private
    # Only allow a trusted parameter "white list" through.
    def admin_rsync_acl_params
      params.require(:rsync_acl).permit(:host)
    end

    def rsyncl_acl_params
      params.require(:id)
    end
end
