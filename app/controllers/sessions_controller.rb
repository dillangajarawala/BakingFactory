class SessionsController < ApplicationController
  include AppHelpers::Cart

    def new
    end

    def create
      user = User.find_by_username(params[:username])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        if user.role?(:admin) || user.role?(:customer)
          create_cart
        end
        if user.role?(:shipper)
          redirect_to shipper_dashboard_path, notice: "Logged in!"
        elsif user.role?(:baker)
          redirect_to baker_dashboard_path, notice: "Logged in!"
        elsif user.role?(:customer)
          redirect_to customer_dash_path, notice: "Logged in!"
        else
          redirect_to home_path, notice: "Logged in!"
        end
      else
        flash.now.alert = "Username or password is invalid"
        render "new"
      end
    end

    def destroy
      session[:user_id] = nil
      destroy_cart
      redirect_to home_path, notice: "Logged out!"
    end
end