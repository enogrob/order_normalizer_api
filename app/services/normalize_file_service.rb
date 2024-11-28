class NormalizeFileService
  def self.process(file_path)
  users = {}

  File.readlines(file_path).each do |line|
    user_id = line[0, 10].to_i
    name = line[10, 45].strip
    order_id = line[55, 10].to_i
    product_id = line[65, 10].to_i
    value = line[75, 12].to_f
    date = Date.strptime(line[87, 8], "%Y%m%d")

    user = User.find_or_create_by(user_id: user_id, name: name)
    order = user.orders.find_or_create_by(order_id: order_id, date: date)
    order.update!(total: order.total.to_f + value)
    order.products.create!(product_id: product_id, value: value)

    user = users[user_id] ||= { name: name, orders: {} }
    order = user[:orders][order_id] ||= { date: date, total: 0, products: [] }
    order[:total] += value
    order[:products] << { product_id: product_id, value: value }
  end

  format_response(users)
  end

  def self.format_response(users)
    users.map do |user_id, user_data|
      {
      user_id: user_id,
      name: user_data[:name],
      orders: user_data[:orders].map do |order_id, order_data|
        {
        order_id: order_id,
        total: "%.2f" % order_data[:total],
        date: order_data[:date],
        products: order_data[:products]
        }
      end
      }
    end
  end
end
