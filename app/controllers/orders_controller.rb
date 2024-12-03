class OrdersController < ApplicationController
  def upload
    file = params[:file]

    # Check if the file is empty
    if file.size.zero?
      return render json: { error: 'The uploaded file is empty.' }, status: :unprocessable_entity
    end

    file_path = Rails.root.join('tmp', file.original_filename)
    File.open(file_path, 'wb') do |f|
      f.write(file.read)
    end

    # Preliminary validation
    begin
      validate_file(file_path)
    rescue InvalidFileFormatError => e
      return render json: { error: e.message }, status: :unprocessable_entity
    end

    upload_id = SecureRandom.uuid

    # Create a record to track the upload status
    Upload.create!(upload_id: upload_id, status: 'processing')

    # Enqueue the file processing job with the upload_id
    FileUploadWorker.perform_later(file_path.to_s, upload_id)
    render json: { message: 'File processing started', upload_id: upload_id }, status: :accepted
  end

  def index
    orders = Order.includes(:products, :user).all

    # Add filters for id and date
    orders = orders.where(order_id: params[:id]) if params[:id]
    if params[:start_date] && params[:end_date]
      orders = orders.where(date: params[:start_date]..params[:end_date])
    end

    render json: orders.map { |order| serialize_order(order) }
  end

  def results
    upload = Upload.find_by(upload_id: params[:upload_id])
    if upload.nil?
      render json: { error: 'Upload not found' }, status: :not_found
    elsif upload.status == 'processing'
      render json: { message: 'File is still processing' }, status: :accepted
    else
      users = User.joins(:orders).where(orders: { upload_id: params[:upload_id] }).distinct
      render json: format_response(users)
    end
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

  def format_response(users)
    users.map do |user|
      {
        user_id: user.user_id,
        name: user.name,
        orders: user.orders.map do |order|
          serialize_order(order)
        end
      }
    end
  end

  def validate_file(file_path)
    lines = File.readlines(file_path)
    if lines.empty?
      raise InvalidFileFormatError, "The file is empty."
    end

    lines.each do |line|
      begin
        user_id = line[0, 10].to_i
        name = line[10, 45].strip
        order_id = line[55, 10].to_i
        product_id = line[65, 10].to_i
        value = line[75, 12].to_f
        date = Date.strptime(line[87, 8], "%Y%m%d")
      rescue StandardError => e
        raise InvalidFileFormatError, "Error parsing line: #{line}. Error: #{e.message}"
      end
    end
  end
end
