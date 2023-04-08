require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user) }

  it "is valid" do
    expect(user).to be_valid
  end

  it "uid should be present" do
    user.uid = " "
    expect(user).to be_invalid
  end
end
