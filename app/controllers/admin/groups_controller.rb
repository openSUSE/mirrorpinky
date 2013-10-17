class Admin::GroupsController < ApplicationController
  load_and_authorize_resource :group, only: [:show, :edit, :update, :destroy, :approve]
  # GET /groups
  # GET /groups.json
  def index
    @groups = current_user.is_admin? ? Group : current_user.groups
    @groups = @groups.all
    authorize! :admin, @groups

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new
    authorize! :admin, @group

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @group }
    end
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.create(create_params)
    authorize! :admin, @group
    respond_to do |format|
      if @group.save
        format.html { redirect_to admin_root_path, :notice => 'Group was successfully created.' }
        format.json { render :json => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.json { render :json => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to @group, :notice => 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  private
  def create_params
    params.require(:group).permit(:name)
  end

  def group_params
    params.require(:id)
  end
end
