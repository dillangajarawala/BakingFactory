class HomeController < ApplicationController
  include AppHelpers::Cart
  # authorize_resource

  def home
  end

  def about
  end

  def privacy
  end

  def contact
  end

  def cart
    @order_items = get_list_of_items_in_cart
  end

end