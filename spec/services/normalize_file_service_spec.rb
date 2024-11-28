require 'rails_helper'

RSpec.describe NormalizeFileService, type: :service do
  let(:valid_file) { Rails.root.join('spec/fixtures/files/valid_sample.txt') }

  describe '.process' do
    context 'with a valid file' do
      it 'parses and returns normalized data' do
        result = NormalizeFileService.process(valid_file)

        expect(result).to be_an(Array)
        expect(result.size).to eq(2)

        user = result.first
        expect(user[:user_id]).to eq(1)
        expect(user[:name]).to eq('Zarelli')
        expect(user[:orders].size).to eq(1)

        order = user[:orders].first
        expect(order[:order_id]).to eq(123)
        expect(order[:total]).to eq('1024.48')
        expect(order[:products].size).to eq(2)

        product = order[:products].first
        expect(product[:product_id]).to eq(111)
        expect(product[:value]).to eq(512.24)
      end
    end
  end
end
