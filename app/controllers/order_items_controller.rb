class OrderItemsController < ApplicationController
    before_action :set_order_item, only: [:mark_shipped, :mark_unshipped]

    def mark_unshipped
        @order_item.shipped_on = nil
        @order_item.save!
        redirect_to shipper_dashboard_path, notice: "The item has been marked as unshipped"
    end

    def mark_shipped
        @order_item.shipped_on = Date.today
        @order_item.save!
        if @order_item.order.order_items.unshipped > 0
            redirect_to shipper_dashboard_path, notice: "The item has been marked as shipped"
        else
            redirect_to shipper_dashboard_path, notice: "The order is now fully shipped!"
        end
    end

    private
    def set_order_item
        @order_item = OrderItem.find(params[:id])
    end
end