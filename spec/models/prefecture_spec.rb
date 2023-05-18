require 'rails_helper'

RSpec.describe Prefecture do
  let(:prefecture) { build(:prefecture) }

  context "with valid attributes" do
    it "is valid" do
      expect(prefecture).to be_valid
    end
  end

  context "without name" do
    before { prefecture.name = nil }

    it "is invalid" do
      expect(prefecture).to be_invalid
    end
  end

  context "with empty name" do
    before { prefecture.name = "" }

    it "is invalid" do
      expect(prefecture).to be_invalid
    end
  end

  context "without image_path" do
    before { prefecture.image_path = nil }

    it "is invalid" do
      expect(prefecture).to be_invalid
    end
  end

  context "with empty image_path" do
    before { prefecture.image_path = "" }

    it "is invalid" do
      expect(prefecture).to be_invalid
    end
  end
end
