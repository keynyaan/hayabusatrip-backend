require 'rails_helper'

RSpec.describe Trip do
  let(:trip) { build(:trip) }

  context "with valid attributes" do
    it "is valid" do
      expect(trip).to be_valid
    end
  end

  context "without title" do
    before { trip.title = nil }

    it "is invalid" do
      expect(trip).to be_invalid
    end
  end

  context "with empty title" do
    before { trip.title = "" }

    it "is invalid" do
      expect(trip).to be_invalid
    end
  end

  context "with title length equal to maximum limit" do
    before { trip.title = "a" * 30 }

    it "is valid" do
      expect(trip).to be_valid
    end
  end

  context "with title length more than maximum limit" do
    before { trip.title = "a" * 31 }

    it "is invalid" do
      expect(trip).to be_invalid
    end
  end

  context "without start_date" do
    before { trip.start_date = nil }

    it "is invalid" do
      expect(trip).to be_invalid
    end
  end

  context "without end_date" do
    before { trip.end_date = nil }

    it "is invalid" do
      expect(trip).to be_invalid
    end
  end

  context "with start_date equal to end_date" do
    before do
      trip.start_date = Time.zone.today
      trip.end_date = Time.zone.today
    end

    it "is valid" do
      expect(trip).to be_valid
    end
  end

  context "with start_date greater than end_date" do
    before do
      trip.start_date = Time.zone.today + 1.day
      trip.end_date = Time.zone.today
    end

    it "is invalid" do
      expect(trip).to be_invalid
    end
  end

  context "with end_date within 10 days of start_date" do
    before do
      trip.start_date = Time.zone.today
      trip.end_date = Time.zone.today + 10.days
    end

    it "is valid" do
      expect(trip).to be_valid
    end
  end

  context "with end_date more than 10 days after start_date" do
    before do
      trip.start_date = Time.zone.today
      trip.end_date = Time.zone.today + 11.days
    end

    it "is invalid" do
      expect(trip).to be_invalid
    end
  end

  context "with memo length equal to maximum limit" do
    before { trip.memo = "a" * 1000 }

    it "is valid" do
      expect(trip).to be_valid
    end
  end

  context "with memo length more than maximum limit" do
    before { trip.memo = "a" * 1001 }

    it "is invalid" do
      expect(trip).to be_invalid
    end
  end

  context "without image_path" do
    before { trip.image_path = nil }

    it "is invalid" do
      expect(trip).to be_invalid
    end
  end

  context "with empty image_path" do
    before { trip.image_path = "" }

    it "is invalid" do
      expect(trip).to be_invalid
    end
  end

  context "with nil is_public" do
    before { trip.is_public = nil }

    it "is invalid" do
      expect(trip).to be_invalid
    end
  end

  context "with true is_public" do
    before { trip.is_public = true }

    it "is valid" do
      expect(trip).to be_valid
    end
  end

  context "with false is_public" do
    before { trip.is_public = false }

    it "is valid" do
      expect(trip).to be_valid
    end
  end

  context "without trip_token" do
    before { trip.trip_token = nil }

    it "is invalid" do
      expect(trip).to be_invalid
    end
  end

  context "with empty trip_token" do
    before { trip.trip_token = "" }

    it "is invalid" do
      expect(trip).to be_invalid
    end
  end

  context "with non-unique trip_token" do
    let(:trip_with_same_token) { build(:trip, trip_token: trip.trip_token) }

    it "is invalid" do
      trip.save
      expect(trip_with_same_token).to be_invalid
    end
  end
end
