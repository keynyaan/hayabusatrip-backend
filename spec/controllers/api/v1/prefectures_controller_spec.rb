require 'rails_helper'

RSpec.describe Api::V1::PrefecturesController do
  let!(:prefectures) { create_list(:prefecture, 47) }

  describe "GET /api/v1/prefectures" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "returns all prefectures" do
      get :index
      expect(response.parsed_body.size).to eq(47)
    end
  end

  describe "GET /api/v1/prefectures/:id" do
    context "when prefecture exists" do
      let(:prefecture) { prefectures.first }

      it "returns http success" do
        get :show, params: { id: prefecture.id }
        expect(response).to have_http_status(:success)
      end

      it "returns correct prefecture data" do
        get :show, params: { id: prefecture.id }
        expect(response.parsed_body["id"]).to eq(prefecture.id)
      end
    end

    context "when prefecture does not exist" do
      it "returns http not_found" do
        get :show, params: { id: -1 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
