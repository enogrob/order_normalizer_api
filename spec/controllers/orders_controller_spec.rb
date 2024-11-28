require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe 'POST #upload' do
    let(:valid_file_path) { 'spec/fixtures/files/valid_sample.txt' }
    let(:invalid_file_path) { 'spec/fixtures/files/invalid_sample.txt' }
    let(:empty_file_path) { 'spec/fixtures/files/empty_sample.txt' }

    context 'with valid file' do
      it 'returns a successful response' do
        allow(NormalizeFileService).to receive(:process).and_return([])

        post :upload, params: { file: valid_file_path }

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('[]')
      end
    end

    context 'with invalid file' do
      it 'returns an error response' do
        allow(NormalizeFileService).to receive(:process).and_raise(InvalidFileFormatError, 'Invalid file format')

        post :upload, params: { file: invalid_file_path }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq('error' => 'Invalid file format')
      end
    end

    context 'with empty file' do
      it 'returns a successful response with an empty array' do
        allow(NormalizeFileService).to receive(:process).and_return([])

        post :upload, params: { file: empty_file_path }

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('[]')
      end
    end
  end

  describe 'GET #index' do
    let!(:user) { create(:user) }
    let!(:order) { create(:order, user: user) }
    let!(:product) { create(:product, order: order) }

    it 'returns a list of orders' do
      get :index

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([
        {
          'order_id' => order.order_id,
          'total' => '%.2f' % order.total,
          'date' => order.date.to_s,
          'products' => [
            {
              'product_id' => product.product_id,
              'value' => '%.2f' % product.value
            }
          ]
        }
      ])
    end

    it 'filters orders by id' do
      get :index, params: { id: order.order_id }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end

    it 'filters orders by date range' do
      get :index, params: { start_date: order.date, end_date: order.date }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end
end
