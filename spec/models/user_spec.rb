require 'rails_helper'

RSpec.describe User do
  let(:user) { build(:user) }

  context "with valid attributes" do
    it "is valid" do
      expect(user).to be_valid
    end
  end

  context "without uid" do
    before { user.uid = nil }

    it "is invalid" do
      expect(user).to be_invalid
    end
  end

  context "with empty uid" do
    before { user.uid = "" }

    it "is invalid" do
      expect(user).to be_invalid
    end
  end

  context "without name" do
    before { user.name = nil }

    it "is invalid" do
      expect(user).to be_invalid
    end
  end

  context "with empty name" do
    before { user.name = "" }

    it "is invalid" do
      expect(user).to be_invalid
    end
  end

  context "without icon_path" do
    before { user.icon_path = nil }

    it "is invalid" do
      expect(user).to be_invalid
    end
  end

  context "with empty icon_path" do
    before { user.icon_path = "" }

    it "is invalid" do
      expect(user).to be_invalid
    end
  end

  context "without request_count" do
    before { user.request_count = nil }

    it "is invalid" do
      expect(user).to be_invalid
    end
  end

  context "with default values" do
    it "has default name '新規ユーザー'" do
      expect(user.name).to eq("新規ユーザー")
    end

    it "has default icon_path '/images/default-user-icon.png'" do
      expect(user.icon_path).to eq("/images/default-user-icon.png")
    end

    it "has default request_count 0" do
      expect(user.request_count).to eq(0)
    end
  end
end
