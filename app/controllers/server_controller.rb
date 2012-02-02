class ServerController < ApplicationController
#  before_filter :authorize

  def index
    @servers = Server.where(:enabled => true).order('region, country, identifier').includes(%w{region country})
    @markers = Marker.all
    flash[:success] = 'woohoo!'
    flash[:info] = 'hello!'
    flash[:warning] = 'alarm!'
    flash[:error] = 'dead!'
  end

  def list
    @markers = Marker.where("subtree_name like ?", params[:distro] + '%' ).all
    @marker_files = MirrorFile.where(:path => @markers.map(&:markers)).select(:mirrors)
    @servers = Server.where(:enabled => true).order('region, country, identifier').includes(%w{region country})
    render :template => 'server/index'
  end
end
