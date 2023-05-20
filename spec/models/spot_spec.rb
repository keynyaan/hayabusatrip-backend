require 'rails_helper'

RSpec.describe Spot do
  let(:spot) { build(:spot) }

  context "with valid attributes" do
    it "is valid" do
      expect(spot).to be_valid
    end
  end

  context "without spot_icon" do
    before { spot.spot_icon = nil }

    it "is invalid" do
      expect(spot).to be_invalid
    end
  end

  context "with empty spot_icon" do
    before { spot.spot_icon = "" }

    it "is invalid" do
      expect(spot).to be_invalid
    end
  end

  context "without title" do
    before { spot.title = nil }

    it "is invalid" do
      expect(spot).to be_invalid
    end
  end

  context "with empty title" do
    before { spot.title = "" }

    it "is invalid" do
      expect(spot).to be_invalid
    end
  end

  context "with title length equal to maximum limit" do
    before { spot.title = "a" * 30 }

    it "is valid" do
      expect(spot).to be_valid
    end
  end

  context "with title length more than maximum limit" do
    before { spot.title = "a" * 31 }

    it "is invalid" do
      expect(spot).to be_invalid
    end
  end

  context "without date" do
    before { spot.date = nil }

    it "is invalid" do
      expect(spot).to be_invalid
    end
  end

  context "without start_time" do
    before { spot.start_time = nil }

    it "is invalid" do
      expect(spot).to be_invalid
    end
  end

  context "without end_time" do
    before { spot.end_time = nil }

    it "is invalid" do
      expect(spot).to be_invalid
    end
  end

  context "with start_time equal to end_time" do
    before do
      time = Time.zone.now
      spot.start_time = time
      spot.end_time = time
    end

    it "is valid" do
      expect(spot).to be_valid
    end
  end

  context "with start_time less than end_time" do
    before do
      spot.start_time = Time.zone.now
      spot.end_time = 1.hour.from_now
    end

    it "is valid" do
      expect(spot).to be_valid
    end
  end

  context "with start_time greater than end_time" do
    before do
      spot.start_time = 1.hour.from_now
      spot.end_time = Time.zone.now
    end

    it "is invalid" do
      expect(spot).to be_invalid
    end
  end

  context "without cost" do
    before { spot.cost = nil }

    it "is invalid" do
      expect(spot).to be_invalid
    end
  end
end
