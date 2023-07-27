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
      time = '12:00'
      spot.start_time = time
      spot.end_time = time
    end

    it "is valid" do
      expect(spot).to be_valid
    end
  end

  context "with start_time less than end_time" do
    before do
      spot.start_time = '12:00'
      spot.end_time = '13:00'
    end

    it "is valid" do
      expect(spot).to be_valid
    end
  end

  context "with start_time greater than end_time" do
    before do
      spot.start_time = '12:00'
      spot.end_time = '11:00'
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

  context "with cost less than 0" do
    before { spot.cost = -1 }

    it "is invalid" do
      expect(spot).to be_invalid
    end
  end

  context "with cost equal to 0" do
    before { spot.cost = 0 }

    it "is valid" do
      expect(spot).to be_valid
    end
  end

  context "with cost more than 99999999" do
    before { spot.cost = 100000000 }

    it "is invalid" do
      expect(spot).to be_invalid
    end
  end

  context "with cost equal to 99999999" do
    before { spot.cost = 99999999 }

    it "is valid" do
      expect(spot).to be_valid
    end
  end

  context "with memo length equal to maximum limit" do
    before { spot.memo = "a" * 50 }

    it "is valid" do
      expect(spot).to be_valid
    end
  end

  context "with memo length more than maximum limit" do
    before { spot.memo = "a" * 51 }

    it "is invalid" do
      expect(spot).to be_invalid
    end
  end
end
