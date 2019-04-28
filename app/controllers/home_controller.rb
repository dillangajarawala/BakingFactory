class HomeController < ApplicationController
  include AppHelpers::Cart
  # authorize_resource

  def home
    if logged_in? && current_user.role?(:shipper)
      @unshipped_orders = Order.not_shipped.paginate(:page => params[:page]).per_page(3)
    elsif logged_in? && current_user.role?(:baker)
      @breads = baking_list("bread")
      @muffins = baking_list("muffins")
      @pastries = baking_list("pastries")
    end
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

end