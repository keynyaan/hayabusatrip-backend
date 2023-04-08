module AuthenticationHelper
  extend ActiveSupport::Concern

  included do
    before do
      allow_any_instance_of(ApplicationController).to receive(:authenticate)
      allow_any_instance_of(Api::V1::UsersController).to receive(:payload_uid).and_return("mock_uid")
    end
  end
end
