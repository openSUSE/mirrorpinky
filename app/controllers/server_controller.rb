class ServerController < ApplicationController
#  before_filter :authorize

  def index
    @servers = Server.where(:enabled => true).order('region, country, identifier').includes(%w{region country})
    @all_markers = Marker.all
   #flash[:success] = 'woohoo!'
   #flash[:info] = 'hello!'
   #flash[:warning] = 'alarm!'
   #flash[:error] = 'dead!'
  end

  def list
    @all_markers = Marker.all
    @markers = []
    if params[:distro]
      @markers = Marker.where("subtree_name like ?", params[:distro] + '%' ).all
    end
    if params[:marker]
      @markers = Marker.where(id: params[:marker])
    end
    @marker_files = MirrorFile.where(:path => @markers.map(&:markers)).select(:mirrors).map(&:mirrors).flatten
    @servers = Server.where(:enabled => true).order('region, country, identifier').includes(%w{region country}).where(id: @marker_files)
    render :template => 'server/index'
  end
end
