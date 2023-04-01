require 'rails_helper'

RSpec.describe "Applications" do
  describe "GET /api/v1/test" do
    it "returns http success" do
      get test_path
      expect(response).to have_http_status(:success)
    end

    it "json object as expected" do
      get test_path
      expect(response.parsed_body[0]["id"]).to eq(1)
      expect(response.parsed_body[0]["title"]).to eq("First Text")
      expect(response.parsed_body[0]["text"]).to eq("最初のテキスト")
      expect(response.parsed_body[1]["id"]).to eq(2)
      expect(response.parsed_body[1]["title"]).to eq("Second Text")
      expect(response.parsed_body[1]["text"]).to eq("2番目のテキスト")
    end
  end
end
