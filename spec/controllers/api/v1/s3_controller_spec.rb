require 'rails_helper'

RSpec.describe Api::V1::S3Controller do
  include ActionDispatch::TestProcess
  include AuthenticationHelper

  describe "POST /api/v1/s3/upload" do
    let(:image_file) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'image_file.png'), 'image/png') }
    let(:non_image_file) {
      fixture_file_upload(Rails.root.join('spec', 'fixtures', 'non_image_file.txt'), 'text/plain')
    }
    let(:big_image_file) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'big_image_file.png'), 'image/png') }

    before do
      # S3用のモック
      s3_resource = instance_double(Aws::S3::Resource)
      allow(Aws::S3::Resource).to receive(:new).and_return(s3_resource)

      s3_bucket = instance_double(Aws::S3::Bucket)
      allow(s3_resource).to receive(:bucket).and_return(s3_bucket)

      s3_object = instance_double(Aws::S3::Object)
      allow(s3_bucket).to receive(:object).and_return(s3_object)

      allow(s3_object).to receive(:upload_file)
      allow(s3_object).to receive(:public_url).and_return("https://example.com/image_file.png")
    end

    context "when file is an image and size is appropriate" do
      it "returns http success and public url" do
        post :upload, params: { file: image_file, filename: 'image_file.png' }
        expect(response).to have_http_status(:success)
        expect(response.parsed_body["location"]).to eq("#{ENV['CLOUDFRONT_DOMAIN']}/image_file.png")
      end
    end

    context "when file is not an image" do
      it "returns unprocessable_entity and error message" do
        post :upload, params: { file: non_image_file, filename: 'non_image_file.txt' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body["error"]).to eq('画像ファイルを選択してください。')
      end
    end

    context "when image file is too big" do
      it "returns unprocessable_entity and error message" do
        post :upload, params: { file: big_image_file, filename: 'big_image_file.png' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body["error"]).to eq('画像ファイルのサイズは5MB以下にしてください。')
      end
    end
  end
end
