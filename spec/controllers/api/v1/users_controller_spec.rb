require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  include AuthenticationHelper

  before do
    request.format = :json
  end

  describe "GET /api/v1/users" do
    let!(:user) { create(:user) }

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "returns all users" do
      get :index
      expect(response.parsed_body.size).to eq(1)
    end
  end

  describe "GET /api/v1/users/:uid" do
    let!(:user) { create(:user) }

    context "when user exists" do
      it "returns http success" do
        get :show, params: { uid: user.uid }
        expect(response).to have_http_status(:success)
      end

      it "returns correct user data" do
        get :show, params: { uid: user.uid }
        expect(response.parsed_body["uid"]).to eq(user.uid)
      end
    end

    context "when user does not exist" do
      it "returns http success" do
        get :show, params: { uid: "nonexistent_uid" }
        expect(response).to have_http_status(:success)
      end

      it "returns null" do
        get :show, params: { uid: "nonexistent_uid" }
        expect(response.parsed_body).to be_nil
      end
    end
  end

  describe "POST /api/v1/users" do
    let(:valid_params) { { user: attributes_for(:user) } }
    let(:invalid_params) { { user: attributes_for(:user, uid: "") } }

    context "with valid parameters" do
      it "creates a new user" do
        expect {
          post :create, params: valid_params
        }.to change(User, :count).by(1)
      end

      it "returns http success" do
        post :create, params: valid_params
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid parameters" do
      it "does not create a new user" do
        expect {
          post :create, params: invalid_params
        }.not_to change(User, :count)
      end

      it "returns http unprocessable_entity" do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT /api/v1/users/:uid" do
    let!(:user) { create(:user) }
    let(:new_attributes) { { user: { name: "Updated User" } } }
    let(:invalid_attributes) { { user: { uid: "" } } }

    context "with valid parameters" do
      it "updates the requested user" do
        put :update, params: { uid: user.uid }.merge(new_attributes)
        user.reload
        expect(user.name).to eq("Updated User")
      end

      it "returns http success" do
        put :update, params: { uid: user.uid }.merge(new_attributes)
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid parameters" do
      it "does not update the requested user" do
        put :update, params: { uid: user.uid }.merge(invalid_attributes)
        user.reload
        expect(user.uid).not_to be_empty
      end

      it "returns http unprocessable_entity" do
        put :update, params: { uid: user.uid }.merge(invalid_attributes)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when user does not exist" do
      it "returns not found" do
        put :update, params: { uid: "nonexistent_uid" }.merge(new_attributes)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /api/v1/users/:uid" do
    let!(:user) { create(:user) }

    context "when user exists" do
      it "destroys the requested user" do
        expect {
          delete :destroy, params: { uid: user.uid }
        }.to change(User, :count).by(-1)
      end

      it "returns no content" do
        delete :destroy, params: { uid: user.uid }
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when user does not exist" do
      it "returns not found" do
        delete :destroy, params: { uid: "nonexistent_uid" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
