require 'rails_helper'

RSpec.describe "Applications", type: :request do
  
  describe "GET /api/v1/test" do

    it "returns http success" do
      get test_path
      expect(response).to have_http_status(:success)
    end
    
    it "json object as expected" do
      get test_path
      expect(JSON.parse(response.body)[0]["id"]).to eq(1)
      expect(JSON.parse(response.body)[0]["title"]).to eq("First Text")
      expect(JSON.parse(response.body)[0]["text"]).to eq("最初のテキスト")
      expect(JSON.parse(response.body)[1]["id"]).to eq(2)
      expect(JSON.parse(response.body)[1]["title"]).to eq("Second Text")
      expect(JSON.parse(response.body)[1]["text"]).to eq("2番目のテキスト")
    end
  end
end