class UsersController < ApplicationController
    before_action :current_user, only: [:show, :edit]
    before_action :set_user, only: [:show, :edit, :update, :deactivate, :activate]
    before_action :check_login
    before_action :get_num_items
    authorize_resource

    def index
      @non_customer_users = User.all.employees.paginate(:page => params[:page]).per_page(10)
    end

    def new
        @user = User.new
    end

    def edit
    end

    def create
        @user = User.new(user_params)
        if @user.save
          redirect_to users_url, :notice => 'User was successfully created.'
        else
          render :action => "new"
        end
      end
    
      # PATCH/PUT /genres/1
      # PATCH/PUT /genres/1.json
    def update
      if @user.update_attributes(user_params)
        redirect_to users_url, :notice => 'User was successfully updated.'
      else
        render :action => "edit"
      end
    end

    def activate
      @user.make_active
      redirect_to users_url, notice: "#{@user.username} was activated"
    end
    
    def deactivate
      @user.make_inactive
      redirect_to users_url, notice: "#{@user.username} was deactivated"
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :role, :password, :password_confirmation)
    end
end