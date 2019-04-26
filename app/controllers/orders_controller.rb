class OrdersController < ApplicationController
  include AppHelpers::Cart
  include AppHelpers::Shipping

  before_action :set_order, only: [:show, :destroy]
  authorize_resource
  
  def index
    if current_user.role?(:admin)
      @all_orders = Order.chronological.paginate(:page => params[:page]).per_page(10)
    elsif current_user.role?(:customer)
      @all_orders = Order.chronological.for_customer(current_user.customer.id).paginate(:page => params[:page]).per_page(10)
    end
  end

  def show
    @previous_orders = @order.customer.orders.chronological.to_a
  end

  def new
    @order = Order.new
    @order_subtotal = calculate_cart_items_cost
    @shipping_costs = calculate_cart_shipping
  end

  def create
    @order_subtotal = calculate_cart_items_cost
    @shipping_costs = calculate_cart_shipping
    @order = Order.new(order_params)
    @order.date = Date.current
    @order.customer_id = current_user.customer.id
    @order.credit_card_number = @order.credit_card_number
    @order.expiration_year = @order.expiration_year.to_i
    @order.expiration_month = @order.expiration_month.to_i
    @order.grand_total = @order_subtotal + @shipping_costs
    if @order.save
      clear_cart
      @order.pay
      save_each_item_in_cart(@order)
      redirect_to @order, notice: "Thank you for ordering from the Baking Factory."
    else
      render action: 'new'
    end
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    if logged_in? && current_user.role?(:admin)
      params.require(:order).permit(:address_id, :customer_id, :grand_total, :credit_card_number, :expiration_year, :expiration_month)
    elsif logged_in? && current_user.role?(:customer)
      params.require(:order).permit(:address_id, :credit_card_number, :expiration_year, :expiration_month)
    end
  end

end