class ServerController < ApplicationController
  def index
    @servers = Server.where(:enabled => true).order('region, country, identifier')
  end

end
