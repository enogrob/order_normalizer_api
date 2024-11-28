class OrdersController < ApplicationController
  def upload
    file = params[:file]
    begin
      result = NormalizeFileService.process(file)
      render json: result
    rescue InvalidFileFormatError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def index
    orders = Order.includes(:products, :user).all

    # Adicione filtros de id e data
    orders = orders.where(order_id: params[:id]) if params[:id]
    if params[:start_date] && params[:end_date]
      orders = orders.where(date: params[:start_date]..params[:end_date])
    end

    render json: orders.map { |order| serialize_order(order) }
  end

  private

  def serialize_order(order)
    {
      order_id: order.order_id,
      total: "%.2f" % order.total,
      date: order.date,
      products: order.products.map do |product|
        { product_id: product.product_id, value: "%.2f" % product.value }
      end
    }
  end
end
