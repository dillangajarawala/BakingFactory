class HomeController < ApplicationController
  include AppHelpers::Cart
  before_action :get_num_items
  # authorize_resource

  def home
  end

  def shipper
    @unshipped_orders = Order.not_shipped.paginate(:page => params[:page]).per_page(3)
  end

  def baker
    @breads = baking_list("bread")
    @muffins = baking_list("muffins")
    @pastries = baking_list("pastries")
  end

  def customer
    if logged_in? && current_user.role?(:customer)
    @previous_orders = current_user.customer.orders.chronological.to_a
    all_previous_items = get_previous_items
    @previous_items = all_previous_items[0,4]
    @recommended_item = (Item.all - all_previous_items).first
    @line = false
    @data = [1,2,3]
    end
  end

  def admin
    set_sales_information
    @num_active_customers = Customer.active.size
    @num_inactive_customers = Customer.all.size - @num_active_customers
    @num_active_items = Item.active.size
    @num_inactive_items = Item.all.size - @num_active_items
    @average_items_per_order = Order.all.inject(0){|sum, o| sum += o.order_items.size}/Order.all.size
  end

  def set_sales_information
    @days = (1.week.ago.to_date..Date.today).map{ |date| date.strftime("%m/%d") }
    @days_totals = (1.week.ago.to_date..Date.today).map{ |date| Order.where(date: date).inject(0){ |sum, o| sum += o.grand_total}}
    @weeks = [4.weeks.ago.to_date, 3.weeks.ago.to_date, 2.weeks.ago.to_date, 1.week.ago.to_date, Date.today]
    @weeks_totals = get_order_totals(@weeks)
    @weeks = @weeks.map{ |date| 'Week of ' + date.strftime("%m/%d")}
    @months = (0..12).to_a.reverse.map{ |n| n.months.ago}
    @months_totals = get_order_totals(@months)
    @months = @months.map{ |m| m.strftime("%B")[0,3]}
  end

  def get_order_totals(arr)
    order_totals = []
    for x in 0..arr.size - 1
      if x != arr.size - 1
        total = Order.where(:date => arr[x].beginning_of_day..arr[x+1].end_of_day).inject(0){|sum, o| sum += o.grand_total}
        order_totals << total
      end
    end
    order_totals
  end

  def about
  end

  def privacy
  end

  def contact
  end

  def cart
    @order_items = get_list_of_items_in_cart
    @order_subtotal = calculate_cart_items_cost
  end

  def search
    @query = params[:query]
    @customers = Customer.search(@query)
    @items = Item.search(@query)
    if logged_in? && current_user.role?(:admin)
      @total_hits = @customers.size + @items.size
    elsif logged_in? && current_user.role?(:customer)
      @total_hits = @items.size
    end
  end

  private
  def get_num_items
    if logged_in? && (current_user.role?(:admin) || current_user.role?(:customer))
      @num = 0
      session[:cart].keys.each do |key|
        @num += session[:cart][key]
      end
    end
  end

  def get_previous_items
    items = []
    orders = Order.for_customer(current_user.customer.id).chronological
    orders.each do |o|
      o.items.each do |i|
        if !items.include?(i)
          items << i
        end
      end
    end
    items
  end

  def baking_list(category)
    order_items = OrderItem.unshipped
    items = Hash.new
    order_items.each do |oi|
      if oi.item.category == category
        if !items.keys.include?(oi.item)
          items[oi.item] = oi.quantity
        else
          items[oi.item] += oi.quantity
        end
      end
    end
    items
  end

end