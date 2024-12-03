class NormalizeFileService
  def self.process(file_path, upload_id)
    users = {}

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

      user = User.find_or_create_by(user_id: user_id, name: name)
      order = user.orders.find_or_create_by(order_id: order_id, date: date, upload_id: upload_id)
      order.update!(total: order.total.to_f + value)
      order.products.create!(product_id: product_id, value: value)

      user = users[user_id] ||= { name: name, orders: {} }
      order = user[:orders][order_id] ||= { date: date, total: 0, products: [] }
      order[:total] += value
      order[:products] << { product_id: product_id, value: value }
      order[:upload_id] = upload_id
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
