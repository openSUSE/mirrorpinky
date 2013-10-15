class ApplicationController < ActionController::Base
  before_filter :preload_regions, :set_current_user
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  private
  def preload_regions
    @regions = Region.order(:name).load
    @all_markers = Marker.all
  end

  # for model based access control
  def set_current_user
#    Authorization.current_user = current_user
Rails.logger.debug(current_user.inspect)
  end

  def require_valid_user
    redirect_to new_user_ichain_session_path unless user_signed_in?
  end

  # rescue_from CanCan::AccessDenied do |exception|
  #   Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
  #   # redirect_to root_url, :alert => exception.message
  # end
end
