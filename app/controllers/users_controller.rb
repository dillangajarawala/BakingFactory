class UsersController < ApplicationController
    before_action :current_user, only: [:show, :edit]
    before_action :set_user, only: [:show, :edit]
    before_action :check_login
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
        session[:user_id] = @user.id
          redirect_to(@user, :notice => 'User was successfully created.')
        else
          render :action => "new"
        end
      end
    
      # PATCH/PUT /genres/1
      # PATCH/PUT /genres/1.json
      def update
        if @user.update_attributes(user_params)
          redirect_to(@user, :notice => 'User was successfully updated.')
        else
          render :action => "edit"
        end
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