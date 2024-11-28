require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let!(:user) { create(:user, user_id: 1, name: 'Zarelli') }
  let!(:order) { create(:order, order_id: 123, user: user, total: 1024.48, date: '2021-12-01') }
  let!(:product1) { create(:product, product_id: 111, value: 512.24, order: order) }
  let!(:product2) { create(:product, product_id: 122, value: 512.24, order: order) }

  describe 'POST #upload' do
    context 'with a valid file' do
      it 'returns the processed data' do
        file = fixture_file_upload('valid_sample.txt', 'text/plain')

        post :upload, params: { file: file }
        expect(response).to have_http_status(:ok)

        result = JSON.parse(response.body, symbolize_names: true)
        expect(result.size).to eq(2)

        user = result.first
        expect(user[:user_id]).to eq(1)
        expect(user[:name]).to eq('Zarelli')
        expect(user[:orders].size).to eq(1)

        order = user[:orders].first
        expect(order[:order_id]).to eq(123)
        expect(order[:total]).to eq('1024.48')
        expect(order[:products].size).to eq(2)
      end
    end
  end

  describe 'GET #index' do
    context 'without filters' do
      it 'returns all orders' do
        get :index
        expect(response).to have_http_status(:ok)

        result = JSON.parse(response.body, symbolize_names: true)
        expect(result.size).to eq(1)

        order = result.first
        expect(order[:order_id]).to eq(123)
        expect(order[:total]).to eq('1024.48')
        expect(order[:products].size).to eq(2)
      end
    end

    context 'with order_id filter' do
      it 'returns the filtered order' do
        get :index, params: { id: 123 }
        expect(response).to have_http_status(:ok)

        result = JSON.parse(response.body, symbolize_names: true)
        expect(result.size).to eq(1)
        expect(result.first[:order_id]).to eq(123)
      end
    end

    context 'with date range filter' do
      it 'returns orders within the specified range' do
        get :index, params: { start_date: '2021-12-01', end_date: '2021-12-31' }
        expect(response).to have_http_status(:ok)

        result = JSON.parse(response.body, symbolize_names: true)
        expect(result.size).to eq(1)
        expect(result.first[:order_id]).to eq(123)
      end

      it 'returns no orders outside the specified range' do
        get :index, params: { start_date: '2020-01-01', end_date: '2020-12-31' }
        expect(response).to have_http_status(:ok)

        result = JSON.parse(response.body, symbolize_names: true)
        expect(result).to be_empty
      end
    end
  end
end
