FactoryBot.define do
  factory :order do
    order_id { 123 }
    total { 1024.48 }
    date { '2021-12-01' }
    user
  end
end
