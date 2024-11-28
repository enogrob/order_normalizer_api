require 'rails_helper'

RSpec.describe NormalizeFileService do
  describe '.process' do
    let(:valid_file_path) { 'spec/fixtures/files/valid_sample.txt' }
    let(:invalid_file_path) { 'spec/fixtures/files/invalid_sample.txt' }
    let(:empty_file_path) { 'spec/fixtures/files/empty_sample.txt' }

    context 'with valid file' do
      it 'processes the file successfully' do
        result = NormalizeFileService.process(valid_file_path)
        expect(result).to be_an(Array)
      end
    end

    context 'with invalid file' do
      it 'raises InvalidFileFormatError' do
        expect {
          NormalizeFileService.process(invalid_file_path)
        }.to raise_error(InvalidFileFormatError, /Error parsing line/)
      end
    end

    context 'with empty file' do
      it 'raises InvalidFileFormatError' do
        expect {
          NormalizeFileService.process(empty_file_path)
        }.to raise_error(InvalidFileFormatError, "The file is empty.")
      end
    end
  end
end
