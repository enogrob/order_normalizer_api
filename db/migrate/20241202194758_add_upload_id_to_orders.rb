class AddUploadIdToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :upload_id, :string
  end
end
