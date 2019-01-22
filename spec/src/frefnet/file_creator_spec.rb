require 'rails_helper'

describe Frefnet::FileCreator do
  let(:original_filename) { 'test.pdf' }

  subject { described_class.new(original_filename: original_filename) }

  describe '#run' do
    it 'creates a frefnet file reference with a guid key and content type guess' do
      expect(SecureRandom).to receive(:uuid).and_call_original
      ref = subject.run
      key_split = ref.key.split('/')
      expect(key_split.first).to eq('file_storage')
      expect(ref.content_type).to eq('application/pdf')
      expect(ref.original_filename).to eq(original_filename)
    end
  end
end
