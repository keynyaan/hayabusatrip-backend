require 'rails_helper'

RSpec.describe Api::V1::SpotsController do
  include AuthenticationHelper

  before do
    request.format = :json
  end

  let!(:trip) { create(:trip) }

  describe "GET /api/v1/trips/:trip_trip_token/spots/:id" do
    let!(:spot) { create(:spot, trip: trip) }

    context "when spot exists" do
      it "returns http success" do
        get :show, params: { trip_trip_token: trip.trip_token, id: spot.id }
        expect(response).to have_http_status(:success)
      end

      it "returns correct spot data" do
        get :show, params: { trip_trip_token: trip.trip_token, id: spot.id }
        expect(response.parsed_body["id"]).to eq(spot.id)
      end
    end

    context "when spot does not exist" do
      it "returns not found" do
        get :show, params: { trip_trip_token: trip.trip_token, id: "nonexistent_id" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /api/v1/trips/:trip_trip_token/spots" do
    let(:valid_params) { { spot: attributes_for(:spot) } }
    let(:invalid_params) { { spot: attributes_for(:spot).merge(title: "") } }

    context "with valid parameters" do
      it "creates a new spot" do
        expect {
          post :create, params: { trip_trip_token: trip.trip_token }.merge(valid_params)
        }.to change(Spot, :count).by(1)
      end

      it "returns http success" do
        post :create, params: { trip_trip_token: trip.trip_token }.merge(valid_params)
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid parameters" do
      it "does not create a new spot" do
        expect {
          post :create, params: { trip_trip_token: trip.trip_token }.merge(invalid_params)
        }.not_to change(Spot, :count)
      end

      it "returns http unprocessable_entity" do
        post :create, params: { trip_trip_token: trip.trip_token }.merge(invalid_params)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT /api/v1/trips/:trip_trip_token/spots/:id" do
    let!(:spot) { create(:spot, trip: trip) }
    let(:new_attributes) { { spot: { title: "Updated Spot" } } }
    let(:invalid_attributes) { { spot: { title: "" } } }

    context "with valid parameters" do
      it "updates the requested spot" do
        put :update, params: { trip_trip_token: trip.trip_token, id: spot.id }.merge(new_attributes)
        spot.reload
        expect(spot.title).to eq("Updated Spot")
      end

      it "returns http success" do
        put :update, params: { trip_trip_token: trip.trip_token, id: spot.id }.merge(new_attributes)
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid parameters" do
      it "does not update the requested spot" do
        put :update, params: { trip_trip_token: trip.trip_token, id: spot.id }.merge(invalid_attributes)
        spot.reload
        expect(spot.title).not_to be_empty
      end

      it "returns http unprocessable_entity" do
        put :update, params: { trip_trip_token: trip.trip_token, id: spot.id }.merge(invalid_attributes)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when spot does not exist" do
      it "returns not found" do
        put :update, params: { trip_trip_token: trip.trip_token, id: "nonexistent_id" }.merge(new_attributes)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /api/v1/trips/:trip_trip_token/spots/:id" do
    let!(:spot) { create(:spot, trip: trip) }

    context "when spot exists" do
      it "destroys the requested spot" do
        expect {
          delete :destroy, params: { trip_trip_token: trip.trip_token, id: spot.id }
        }.to change(Spot, :count).by(-1)
      end

      it "returns http success" do
        delete :destroy, params: { trip_trip_token: trip.trip_token, id: spot.id }
        expect(response).to have_http_status(:success)
      end
    end

    context "when spot does not exist" do
      it "returns not found" do
        delete :destroy, params: { trip_trip_token: trip.trip_token, id: "nonexistent_id" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end