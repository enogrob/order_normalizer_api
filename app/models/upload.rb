# app/models/upload.rb
class Upload < ApplicationRecord
  validates :upload_id, presence: true, uniqueness: true
  validates :status, presence: true
end
