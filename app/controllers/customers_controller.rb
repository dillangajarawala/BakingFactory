class CustomersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  include AppHelpers::Cart
  before_action :set_customer, only: [:show, :edit, :update, :destroy, :activate, :deactivate]
  before_action :get_num_items
  authorize_resource
  
  def index
    @active_customers = Customer.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_customers = Customer.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @previous_orders = @customer.orders.chronological
  end

  def new
    @customer = Customer.new
    user = @customer.build_user
  end

  def edit
    # reformat phone w/ dashes when displayed for editing (preference; not required)
    @customer.phone = number_to_phone(@customer.phone)
    # should have a user associated with customer, but just in case...
        user = (@customer.user.nil? ? @customer.build_user : @customer.user)
  end

  def create
    @customer = Customer.new(customer_params)
    @customer.active = true
    if !@customer.user.nil?
      @customer.user.role = "customer"
      @customer.user.active = true
    end
      if @customer.save
        if logged_in?
          redirect_to @customer, notice: "#{@customer.proper_name} was added to the system."
        else
          redirect_to login_path, notice: "Your account was created. Log in now."
        end
      else
        render action: 'new'
      end
  end

  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: "#{@customer.proper_name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def activate
    @customer.make_active
    redirect_to @customer, notice: "#{@customer.name} was activated"
  end

  def deactivate
    @customer.make_inactive
    redirect_to @customer, notice: "#{@customer.name} was deactivated"
  end

  private
  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :phone, :active, user_attributes: [:username, :password, :password_confirmation])
  end

end