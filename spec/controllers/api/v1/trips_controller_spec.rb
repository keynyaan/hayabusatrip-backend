require 'rails_helper'

RSpec.describe Api::V1::TripsController do
  include AuthenticationHelper

  before do
    request.format = :json
  end

  let!(:user) { create(:user) }

  describe "GET /api/v1/users/:user_uid/trips" do
    let!(:trip1) { create(:trip, user: user) }
    let!(:trip2) { create(:trip, user: user) }

    it "returns http success" do
      get :index, params: { user_uid: user.uid }
      expect(response).to have_http_status(:success)
    end

    it "returns all trips of the user" do
      get :index, params: { user_uid: user.uid }
      expect(response.parsed_body.map { |t| t["trip_token"] }).to contain_exactly(trip1.trip_token, trip2.trip_token)
    end
  end

  describe "GET /api/v1/users/:user_uid/trips/:trip_token" do
    let!(:trip) { create(:trip, user: user) }

    context "when trip exists" do
      it "returns http success" do
        get :show, params: { user_uid: user.uid, trip_token: trip.trip_token }
        expect(response).to have_http_status(:success)
      end

      it "returns correct trip data" do
        get :show, params: { user_uid: user.uid, trip_token: trip.trip_token }
        expect(response.parsed_body["trip_token"]).to eq(trip.trip_token)
      end
    end

    context "when trip does not exist" do
      it "returns not found" do
        get :show, params: { user_uid: user.uid, trip_token: "nonexistent_token" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /api/v1/trips/:trip_token" do
    let!(:public_trip) { create(:trip, is_public: true) }
    let!(:private_trip) { create(:trip, is_public: false) }

    context "when public trip exists" do
      it "returns http success" do
        get :show, params: { trip_token: public_trip.trip_token }
        expect(response).to have_http_status(:success)
      end

      it "returns correct trip data" do
        get :show, params: { trip_token: public_trip.trip_token }
        expect(response.parsed_body["trip_token"]).to eq(public_trip.trip_token)
      end
    end

    context "when public trip does not exist" do
      it "returns not found" do
        get :show, params: { trip_token: "nonexistent_token" }
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when trip is not public" do
      it "returns not found" do
        get :show, params: { trip_token: private_trip.trip_token }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /api/v1/users/:user_uid/trips" do
    let(:prefecture) { create(:prefecture) }
    let(:valid_params) { { user_uid: user.uid, trip: attributes_for(:trip).merge(prefecture_id: prefecture.id) } }
    let(:invalid_prefecture_params) {
      { user_uid: user.uid, trip: attributes_for(:trip).except(:image_path).merge(prefecture_id: 0) }
    }
    let(:invalid_title_params) {
      { user_uid: user.uid, trip: attributes_for(:trip).merge(prefecture_id: prefecture.id, title: "") }
    }

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

    context "with invalid parameters without image path" do
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

    context "with invalid title" do
      it "does not create a new trip with empty title" do
        expect {
          post :create, params: invalid_title_params
        }.not_to change(Trip, :count)
      end

      it "returns http unprocessable_entity with empty title" do
        post :create, params: invalid_title_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT /api/v1/users/:user_uid/trips/:trip_token" do
    let!(:trip) { create(:trip, user: user) }
    let(:new_attributes) { { user_uid: user.uid, trip_token: trip.trip_token, trip: { title: "Updated Trip" } } }
    let(:invalid_attributes) { { user_uid: user.uid, trip_token: trip.trip_token, trip: { title: "" } } }

    context "with valid parameters" do
      it "updates the requested trip" do
        put :update, params: new_attributes
        trip.reload
        expect(trip.title).to eq("Updated Trip")
      end

      it "returns http success" do
        put :update, params: new_attributes
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid parameters" do
      it "does not update the requested trip" do
        put :update, params: invalid_attributes
        trip.reload
        expect(trip.title).not_to be_empty
      end

      it "returns http unprocessable_entity" do
        put :update, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when trip does not exist" do
      it "returns not found" do
        put :update, params: { user_uid: user.uid, trip_token: "nonexistent_token" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /api/v1/users/:user_uid/trips/:trip_token" do
    let!(:trip) { create(:trip, user: user) }

    context "when trip exists" do
      it "destroys the requested trip" do
        expect {
          delete :destroy, params: { user_uid: user.uid, trip_token: trip.trip_token }
        }.to change(Trip, :count).by(-1)
      end

      it "returns no content" do
        delete :destroy, params: { user_uid: user.uid, trip_token: trip.trip_token }
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when trip does not exist" do
      it "returns not found" do
        delete :destroy, params: { user_uid: user.uid, trip_token: "nonexistent_token" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
