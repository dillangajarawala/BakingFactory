class HomeController < ApplicationController
  include AppHelpers::Cart
  # authorize_resource

  def home
    if logged_in? && current_user.role?(:shipper)
      @unshipped_orders = Order.not_shipped.paginate(:page => params[:page]).per_page(3)
    end
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