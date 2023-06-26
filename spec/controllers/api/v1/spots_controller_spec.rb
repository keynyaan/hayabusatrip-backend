require 'rails_helper'

RSpec.describe Api::V1::SpotsController do
  include AuthenticationHelper

  before do
    request.format = :json
  end

  let!(:user) { create(:user) }
  let!(:trip) { create(:trip, user: user) }

  describe "GET /api/v1/users/:user_uid/trips/:trip_trip_token/spots" do
    let!(:spot1) { create(:spot, trip: trip) }
    let!(:spot2) { create(:spot, trip: trip) }

    it "returns http success" do
      get :index, params: { user_uid: user.uid, trip_trip_token: trip.trip_token }
      expect(response).to have_http_status(:success)
    end

    it "returns all spots of the trip" do
      get :index, params: { user_uid: user.uid, trip_trip_token: trip.trip_token }
      expect(response.parsed_body.map { |s| s["id"] }).to contain_exactly(spot1.id, spot2.id)
    end
  end

  describe "GET /api/v1/trips/:trip_token/spots" do
    let!(:trip) { create(:trip, is_public: is_public) }
    let!(:spot1) { create(:spot, trip: trip) }
    let!(:spot2) { create(:spot, trip: trip) }

    context "when the trip is public" do
      let(:is_public) { true }

      it "returns http success" do
        get :index, params: { trip_trip_token: trip.trip_token }
        expect(response).to have_http_status(:success)
      end

      it "returns all spots of the public trip" do
        get :index, params: { trip_trip_token: trip.trip_token }
        expect(response.parsed_body.map { |s| s["id"] }).to contain_exactly(spot1.id, spot2.id)
      end
    end

    context "when the trip is private" do
      let(:is_public) { false }

      it "returns not found" do
        expect {
          get :index, params: { trip_trip_token: trip.trip_token }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "GET /api/v1/users/:user_uid/trips/:trip_trip_token/spots/:id" do
    let!(:spot) { create(:spot, trip: trip) }

    context "when spot exists" do
      it "returns http success" do
        get :show, params: { user_uid: user.uid, trip_trip_token: trip.trip_token, id: spot.id }
        expect(response).to have_http_status(:success)
      end

      it "returns correct spot data" do
        get :show, params: { user_uid: user.uid, trip_trip_token: trip.trip_token, id: spot.id }
        expect(response.parsed_body["id"]).to eq(spot.id)
      end
    end

    context "when spot does not exist" do
      it "returns not found" do
        get :show, params: { user_uid: user.uid, trip_trip_token: trip.trip_token, id: "nonexistent_id" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /api/v1/users/:user_uid/trips/:trip_trip_token/spots" do
    let(:valid_params) { { spot: attributes_for(:spot) } }
    let(:invalid_params) { { spot: attributes_for(:spot).merge(title: "") } }

    context "with valid parameters" do
      it "creates a new spot" do
        expect {
          post :create, params: { user_uid: user.uid, trip_trip_token: trip.trip_token }.merge(valid_params)
        }.to change(Spot, :count).by(1)
      end

      it "returns http success" do
        post :create, params: { user_uid: user.uid, trip_trip_token: trip.trip_token }.merge(valid_params)
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid parameters" do
      it "does not create a new spot" do
        expect {
          post :create, params: { user_uid: user.uid, trip_trip_token: trip.trip_token }.merge(invalid_params)
        }.not_to change(Spot, :count)
      end

      it "returns http unprocessable_entity" do
        post :create, params: { user_uid: user.uid, trip_trip_token: trip.trip_token }.merge(invalid_params)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT /api/v1/users/:user_uid/trips/:trip_trip_token/spots/:id" do
    let!(:spot) { create(:spot, trip: trip) }
    let(:new_attributes) { { spot: { title: "Updated Spot" } } }
    let(:invalid_attributes) { { spot: { title: "" } } }

    context "with valid parameters" do
      it "updates the requested spot" do
        put :update, params: { user_uid: user.uid, trip_trip_token: trip.trip_token, id: spot.id }.merge(new_attributes)
        spot.reload
        expect(spot.title).to eq("Updated Spot")
      end

      it "returns http success" do
        put :update, params: { user_uid: user.uid, trip_trip_token: trip.trip_token, id: spot.id }.merge(new_attributes)
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid parameters" do
      it "does not update the requested spot" do
        put :update,
            params: { user_uid: user.uid, trip_trip_token: trip.trip_token, id: spot.id }.merge(invalid_attributes)
        spot.reload
        expect(spot.title).not_to be_empty
      end

      it "returns ht
           tp unprocessable_entity" do
        put :update,
            params: { user_uid: user.uid, trip_trip_token: trip.trip_token, id: spot.id }.merge(invalid_attributes)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when sp
           ot does not exist" do
      it "returns not found" do
        put :update,
            params: { user_uid: user.uid, trip_trip_token: trip.trip_token, id: "nonexistent_id" }.merge(new_attributes)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /api/v1/users/:user_uid/trips/:trip_trip_token/spots/:id" do
    let!(:spot1) { create(:spot, trip: trip, date: Time.zone.today) }
    let!(:spot2) { create(:spot, trip: trip, date: Time.zone.today) }
    let!(:spot3) { create(:spot, trip: trip, date: Time.zone.tomorrow) }

    context "when spot id exists" do
      it "destroys the requested spot" do
        expect {
          delete :destroy, params: { user_uid: user.uid, trip_trip_token: trip.trip_token, id: spot1.id }
        }.to change(Spot, :count).by(-1)
      end

      it "returns no content" do
        delete :destroy, params: { user_uid: user.uid, trip_trip_token: trip.trip_token, id: spot1.id }
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when spot id does not exist but date exists" do
      it "destroys all spots of the given date" do
        expect {
          delete :destroy, params: { user_uid: user.uid, trip_trip_token: trip.trip_token, date: Time.zone.today }
        }.to change(Spot, :count).by(-2)
      end

      it "returns no content" do
        delete :destroy, params: { user_uid: user.uid, trip_trip_token: trip.trip_token, date: Time.zone.today }
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when neither spot id nor date exists" do
      it "does not destroy any spot" do
        expect {
          delete :destroy,
                 params: { user_uid: user.uid, trip_trip_token: trip.trip_token, id: "nonexistent_id" }
        }.not_to change(Spot, :count)
      end

      it "returns not found" do
        delete :destroy,
               params: { user_uid: user.uid, trip_trip_token: trip.trip_token, id: "nonexistent_id" }
        expect(response).to have_http_status(:not_found)
      end

      it "does not destroy any spot when the date does not exist" do
        expect {
          delete :destroy,
                 params: { user_uid: user.uid, trip_trip_token: trip.trip_token, date: Time.zone.yesterday }
        }.not_to change(Spot, :count)
      end

      it "returns no content when the date does not exist" do
        delete :destroy,
               params: { user_uid: user.uid, trip_trip_token: trip.trip_token, date: Time.zone.yesterday }
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
