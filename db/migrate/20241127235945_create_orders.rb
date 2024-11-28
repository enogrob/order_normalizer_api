class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.integer :order_id
      t.references :user, null: false, foreign_key: true
      t.decimal :total
      t.date :date

      t.timestamps
    end
  end
end
