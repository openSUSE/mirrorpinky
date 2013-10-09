class ApplicationController < ActionController::Base
  before_filter :preload_regions, :set_current_user
  protect_from_forgery
  private
  def preload_regions
    @regions = Region.order(:name).all
  end

  # for model based access control
  def set_current_user
#    Authorization.current_user = current_user
  end

  def require_valid_user
    redirect_to sign_in_path unless current_user
  end
end
