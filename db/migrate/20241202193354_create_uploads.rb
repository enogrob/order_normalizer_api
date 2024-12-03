class CreateUploads < ActiveRecord::Migration[8.0]
  def change
    create_table :uploads do |t|
      t.string :upload_id
      t.string :status

      t.timestamps
    end
  end
end
