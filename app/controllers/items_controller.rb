  class ItemsController < ApplicationController
    include AppHelpers::Cart

  before_action :check_login, except: [:index, :show]
  before_action :set_item, except: [:index, :new, :create]
  before_action :get_num_items
  authorize_resource
  
  def index
    # get info on active items for the big three...
    @breads = Item.active.for_category('bread').alphabetical.paginate(:page => params[:page]).per_page(10)
    @muffins = Item.active.for_category('muffins').alphabetical.paginate(:page => params[:page]).per_page(10)
    @pastries = Item.active.for_category('pastries').alphabetical.paginate(:page => params[:page]).per_page(10)
    # get a list of any inactive items for sidebar
    @inactive_items = Item.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    if logged_in? && current_user.role?(:admin)
      # admin gets a price history in the sidebar
      @previous_prices = @item.item_prices.chronological.to_a
    end
    # everyone sees similar items in the sidebar
    @similar_items = Item.active.for_category(@item.category).alphabetical.to_a - [@item]
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to @item, notice: "#{@item.name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: "#{@item.name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @item.destroy
    if !@item.nil? && !@item.active?
      redirect_to items_url, notice: "#{@item.name} was made inactive, because it cannot be deleted."
    else
      redirect_to items_url, notice: "#{@item.name} was removed from the system."
    end
  end

  def activate
    @item.make_active
    redirect_to items_path, notice: "#{@item.name} was activated"
  end

  def deactivate
    @item.make_inactive
    redirect_to items_path, notice: "#{@item.name} was deactivated"
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end

  def get_num_items
    @num = 0
      session[:cart].keys.each do |key|
        @num += session[:cart][key]
      end
  end

  def item_params
    params.require(:item).permit(:name, :description, :picture, :category, :units_per_item, :weight, :active)
  end

end