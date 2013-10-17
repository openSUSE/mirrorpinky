class Admin::GroupRequestsController < ApplicationController
  # before_action :set_group_request, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :group_request, only: [:show, :edit, :update, :destroy, :approve]
  skip_authorization_check

  # GET /group_requests
  def index
    @group_requests = GroupRequest.all
  end

  # GET /group_requests/1
  def show
  end

  # GET /group_requests/new
  def new
    @group_request = GroupRequest.new
  end

  # GET /group_requests/1/edit
  def edit
  end

  # POST /group_requests
  def create
    authorize! :group_request, :create
    Rails.logger.error "darix was here"
    Rails.logger.debug group_request_params.inspect
    @group_request = GroupRequest.new(group_request_params)
    @group_request.user = current_user
    if @group_request.save
      redirect_to admin_root_url, notice: 'Group request was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /group_requests/1
  def update
    if @group_request.update(group_request_params)
      redirect_to admin_root_url, notice: 'Group request was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /group_requests/1
  def destroy
    @group_request.destroy
    redirect_to admin_root_url, notice: 'Group request was successfully destroyed.'
  end

  def approve
    group = Group.new(name: @group_request.name)
    user  = @group_request.user
    if group.save
      group.users << @group_request.user
      redirect_to admin_group_requests_path, notice: 'Group request successfully accepted.'
    else
      render action: 'index'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_request
      @group_request = GroupRequest.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_request_params
      Rails.logger.debug params.inspect
      params.require(:group_request).permit(:name)
      # params.require(:group_request).permit! # (:name)
    end
end
