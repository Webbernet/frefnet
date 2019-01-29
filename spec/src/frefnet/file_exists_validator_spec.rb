require "rails_helper"

class Aws
  class S3
    class Bucket
    end
  end
end

RSpec.describe Frefnet::FileExistsValidator do
  subject { described_class.new }
  let(:form) { double(errors: form_errors, attributes: [{hello: 'dsadas'}]) }
  let(:form_errors) { double(add: true) }
  let(:mock_object) { double('exists?' => exists) }

  before do
    allow(Frefnet).to receive(:config).and_return(double(bucket: 'test'))
    allow(Aws::S3::Bucket).to receive(:new).and_return(double(object: mock_object))
    allow(Frefnet::FileReference).to receive(:where).and_return(double(map: [1]))
  end

  context "when the files exist" do
    let(:exists) { true }

    it "does not add any errors" do
      expect(form_errors).to_not receive(:add)
      subject.validate(form)
    end
  end

  context "when the files DON'T exist" do
    let(:exists) { false }

    it "adds errors" do
      expect(form_errors).to receive(:add)
      subject.validate(form)
    end
  end
end
