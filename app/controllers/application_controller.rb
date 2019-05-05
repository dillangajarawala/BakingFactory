class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def logged_in?
    current_user
  end
  helper_method :logged_in?

  def check_login
    redirect_to login_url, alert: "You need to log in to view this page." if current_user.nil?
  end

  def get_num_items
    if logged_in? && (current_user.role?(:admin) || current_user.role?(:customer))
      @num = 0
      session[:cart].keys.each do |key|
        @num += session[:cart][key]
      end
    end
    @num
  end
  helper_method :get_num_items

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You are not allowed to view that page"
    redirect_to home_path
  end
end
