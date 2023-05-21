require 'rails_helper'

RSpec.describe Api::V1::TripsController do
  include AuthenticationHelper

  before do
    request.format = :json
  end

  describe "GET /api/v1/trips/:trip_token" do
    let!(:trip) { create(:trip) }

    context "when trip exists" do
      it "returns http success" do
        get :show, params: { trip_token: trip.trip_token }
        expect(response).to have_http_status(:success)
      end

      it "returns correct trip data" do
        get :show, params: { trip_token: trip.trip_token }
        expect(response.parsed_body["trip_token"]).to eq(trip.trip_token)
      end
    end

    context "when trip does not exist" do
      it "returns not found" do
        get :show, params: { trip_token: "nonexistent_token" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /api/v1/trips" do
    let(:user) { create(:user) }
    let(:prefecture) { create(:prefecture) }
    let(:valid_params) { { trip: attributes_for(:trip).merge(user_id: user.id, prefecture_id: prefecture.id) } }
    let(:invalid_user_params) { { trip: attributes_for(:trip).merge(user_id: nil, prefecture_id: prefecture.id) } }
    let(:invalid_prefecture_params) { { trip: attributes_for(:trip).merge(user_id: user.id, prefecture_id: 0) } }

    context "with valid parameters" do
      it "creates a new trip" do
        expect {
          post :create, params: valid_params
        }.to change(Trip, :count).by(1)
      end

      it "returns http success" do
        post :create, params: valid_params
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid parameters" do
      it "does not create a new trip with invalid user_id" do
        expect {
          post :create, params: invalid_user_params
        }.not_to change(Trip, :count)
      end

      it "returns http unprocessable_entity with invalid user_id" do
        post :create, params: invalid_user_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not create a new trip with invalid prefecture_id" do
        expect {
          post :create, params: invalid_prefecture_params
        }.not_to change(Trip, :count)
      end

      it "returns http not_found with invalid prefecture_id" do
        post :create, params: invalid_prefecture_params
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PUT /api/v1/trips/:trip_token" do
    let!(:trip) { create(:trip) }
    let(:new_attributes) { { trip: { title: "Updated Trip" } } }
    let(:invalid_attributes) { { trip: { title: "" } } }

    context "with valid parameters" do
      it "updates the requested trip" do
        put :update, params: { trip_token: trip.trip_token }.merge(new_attributes)
        trip.reload
        expect(trip.title).to eq("Updated Trip")
      end

      it "returns http success" do
        put :update, params: { trip_token: trip.trip_token }.merge(new_attributes)
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid parameters" do
      it "does not update the requested trip" do
        put :update, params: { trip_token: trip.trip_token }.merge(invalid_attributes)
        trip.reload
        expect(trip.title).not_to be_empty
      end

      it "returns http unprocessable_entity" do
        put :update, params: { trip_token: trip.trip_token }.merge(invalid_attributes)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when trip does not exist" do
      it "returns not found" do
        put :update, params: { trip_token: "nonexistent_token" }.merge(new_attributes)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /api/v1/trips/:trip_token" do
    let!(:trip) { create(:trip) }

    context "when trip exists" do
      it "destroys the requested trip" do
        expect {
          delete :destroy, params: { trip_token: trip.trip_token }
        }.to change(Trip, :count).by(-1)
      end

      it "returns http success" do
        delete :destroy, params: { trip_token: trip.trip_token }
        expect(response).to have_http_status(:success)
      end
    end

    context "when trip does not exist" do
      it "returns not found" do
        delete :destroy, params: { trip_token: "nonexistent_token" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
