require 'rails_helper'

RSpec.describe Api::V1::SpotsController do
  include AuthenticationHelper

  before do
    request.format = :json
  end

  let!(:user) { create(:user) }
  let!(:trip) { create(:trip, user: user) }

  describe "GET /api/v1/users/:user_uid/trips/:trip_trip_token/spots" do
    let!(:first_spot) { create(:spot, trip: trip) }
    let!(:second_spot) { create(:spot, trip: trip) }

    it "returns http success" do
      get :index, params: { user_uid: user.uid, trip_trip_token: trip.trip_token }
      expect(response).to have_http_status(:success)
    end

    it "returns all spots of the trip" do
      get :index, params: { user_uid: user.uid, trip_trip_token: trip.trip_token }
      expect(response.parsed_body.map { |s| s["id"] }).to contain_exactly(first_spot.id, second_spot.id)
    end
  end

  describe "GET /api/v1/trips/:trip_token/spots" do
    let!(:trip) { create(:trip, is_public: is_public) }
    let!(:first_spot) { create(:spot, trip: trip) }
    let!(:second_spot) { create(:spot, trip: trip) }

    context "when the trip is public" do
      let(:is_public) { true }

      it "returns http success" do
        get :index, params: { trip_trip_token: trip.trip_token }
        expect(response).to have_http_status(:success)
      end

      it "returns all spots of the public trip" do
        get :index, params: { trip_trip_token: trip.trip_token }
        expect(response.parsed_body.map { |s| s["id"] }).to contain_exactly(first_spot.id, second_spot.id)
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
    let(:invalid_params) { { spot: attributes_for(:spot).merge(name: "") } }

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
    let(:new_attributes) { { spot: { name: "Updated Spot" } } }
    let(:invalid_attributes) { { spot: { name: "" } } }

    context "with valid parameters" do
      it "updates the requested spot" do
        put :update, params: { user_uid: user.uid, trip_trip_token: trip.trip_token, id: spot.id }.merge(new_attributes)
        spot.reload
        expect(spot.name).to eq("Updated Spot")
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
        expect(spot.name).not_to be_empty
      end

      it "returns http unprocessable_entity" do
        put :update,
            params: { user_uid: user.uid, trip_trip_token: trip.trip_token, id: spot.id }.merge(invalid_attributes)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when spot does not exist" do
      it "returns not found" do
        put :update,
            params: { user_uid: user.uid, trip_trip_token: trip.trip_token, id: "nonexistent_id" }.merge(new_attributes)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "with base_date and date_offset parameters" do
      let!(:today_spot) { create(:spot, trip: trip, date: Time.zone.today) }
      let!(:tomorrow_spot) { create(:spot, trip: trip, date: Time.zone.tomorrow) }
      let(:base_date) { Time.zone.today.strftime('%Y-%m-%d') }
      let(:date_offset) { 1 }
      let(:params) do
        {
          user_uid: user.uid,
          trip_trip_token: trip.trip_token,
          base_date: base_date,
          date_offset: date_offset
        }
      end

      it "updates spots with dates after base_date" do
        put :update, params: params
        today_spot.reload
        tomorrow_spot.reload
        expect(today_spot.date).to eq(Time.zone.today)
        expect(tomorrow_spot.date).to eq(Time.zone.today + 2.days)
      end

      it "returns http success" do
        put :update, params: params
        expect(response).to have_http_status(:success)
      end

      context "when date update fails" do
        before do
          allow_any_instance_of(Spot).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)
        end

        it "returns http unprocessable_entity and error message" do
          put :update, params: params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body["error"]["messages"]).to include("日付の更新に失敗しました。")
        end
      end
    end
  end

  describe "DELETE /api/v1/users/:user_uid/trips/:trip_trip_token/spots/:id" do
    let!(:first_today_spot) { create(:spot, trip: trip, date: Time.zone.today) }
    let!(:second_today_spot) { create(:spot, trip: trip, date: Time.zone.today) }
    let!(:tomorrow_spot) { create(:spot, trip: trip, date: Time.zone.tomorrow) }

    context "when spot id exists" do
      it "destroys the requested spot" do
        expect {
          delete :destroy, params: { user_uid: user.uid, trip_trip_token: trip.trip_token, id: first_today_spot.id }
        }.to change(Spot, :count).by(-1)
      end

      it "returns no content" do
        delete :destroy, params: { user_uid: user.uid, trip_trip_token: trip.trip_token, id: first_today_spot.id }
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
