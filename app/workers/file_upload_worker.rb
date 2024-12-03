# app/workers/file_upload_worker.rb
class FileUploadWorker < ApplicationJob
  queue_as :default

  def perform(file_path, upload_id)
    users = NormalizeFileService.process(file_path, upload_id)
    users.each do |user_data|
      user = User.find_or_create_by(user_id: user_data[:user_id], name: user_data[:name])
      user_data[:orders].each do |order_data|
        order = user.orders.find_or_create_by(order_id: order_data[:order_id], date: order_data[:date])
        order.update!(total: order_data[:total], upload_id: upload_id)
        order_data[:products].each do |product_data|
          order.products.create!(product_id: product_data[:product_id], value: product_data[:value])
        end
      end
    end

    # Update the upload status to 'completed'
    upload = Upload.find_by(upload_id: upload_id)
    upload.update!(status: 'completed')
  end
end