class ApplicationController < ActionController::Base
  include Clearance::Authentication
  before_filter :preload_regions
  protect_from_forgery
  private
  def preload_regions
    @regions = Region.order(:name).all
  end
end
