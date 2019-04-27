class OrdersController < ApplicationController
  include AppHelpers::Cart
  include AppHelpers::Shipping

  before_action :set_order, only: [:show, :destroy]
  before_action :set_item, only: [:add_to_cart, :remove_from_cart]
  authorize_resource
  
  def index
    if current_user.role?(:admin)
      @pending_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(10)
      @past_orders = Order.where(id: (Order.chronological - @pending_orders)).paginate(:page => params[:page]).per_page(10)
    elsif current_user.role?(:customer)
      @pending_orders = Order.for_customer(current_user.customer.id).not_shipped.chronological.paginate(:page => params[:page]).per_page(10)
      @past_orders = Order.where(id: (Order.for_customer(current_user.customer.id).chronological - @pending_orders)).paginate(:page => params[:page]).per_page(10)
    end
  end

  def show
    @previous_orders = @order.customer.orders.chronological.to_a - [@order]
    @order_items = @order.order_items
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

  def add_to_cart
    add_item_to_cart(@item.id.to_s)
    redirect_to items_url, notice: "#{@item.name} has been added to your cart"
  end

  def remove_from_cart
    remove_item_from_cart(@item.id.to_s)
    redirect_to cart_path, notice: "#{@item.name} has been removed from your cart"
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def order_params
    if logged_in? && current_user.role?(:admin)
      params.require(:order).permit(:address_id, :customer_id, :grand_total, :credit_card_number, :expiration_year, :expiration_month)
    elsif logged_in? && current_user.role?(:customer)
      params.require(:order).permit(:address_id, :credit_card_number, :expiration_year, :expiration_month)
    end
  end

end