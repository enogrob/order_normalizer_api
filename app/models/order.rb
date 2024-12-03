class Order < ApplicationRecord
  belongs_to :user
  has_many :products

  validates :upload_id, presence: true
end
