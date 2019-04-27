class OrderItemsController < ApplicationController
    before_action :set_order_item, only: [:mark_shipped, :mark_unshipped]

    def mark_unshipped
        @order_item.shipped_on = nil
        @order_item.save!
        redirect_to home_path, notice: "Item has been marked as unshipped"
    end

    def mark_shipped
        @order_item.shipped_on = Date.today
        @order_item.save!
        redirect_to home_path, notice: "Item has been marked as shipped"
    end

    private
    def set_order_item
        @order_item = OrderItem.find(params[:id])
    end
end