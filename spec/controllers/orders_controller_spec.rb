require 'rails_helper'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

RSpec.describe OrdersController, type: :controller do
  before do
    Sidekiq::Worker.clear_all
  end

  describe 'POST #upload' do
    let(:valid_file) { Rack::Test::UploadedFile.new('spec/fixtures/files/valid_sample.txt', 'text/plain') }
    let(:invalid_file) { Rack::Test::UploadedFile.new('spec/fixtures/files/invalid_sample.txt', 'text/plain') }
    let(:empty_file) { Rack::Test::UploadedFile.new('spec/fixtures/files/empty_sample.txt', 'text/plain') }

    context 'with valid file' do
      it 'enqueues a file processing job' do
        post :upload, params: { file: valid_file }
        expect(response).to have_http_status(:accepted)
        expect(Sidekiq::Queues['default'].size).to eq(1)
      end
    end

    context 'with invalid file' do
      it 'returns an error' do
        post :upload, params: { file: invalid_file }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to match(/Error parsing line: 1234567890John Doe\s+12345678901234567890123456789012345678901234567890123456789012345678901234567890\n. Error: invalid date/)
      end
    end

    context 'with empty file' do
      it 'returns an error' do
        post :upload, params: { file: empty_file }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'The uploaded file is empty.' })
      end
    end
  end

  describe 'GET #index' do
    let!(:user) { create(:user) }
    let!(:order) { create(:order, user: user, upload_id: 'test_upload_id') }
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
