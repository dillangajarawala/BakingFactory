class HomeController < ApplicationController
  include AppHelpers::Cart
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

end