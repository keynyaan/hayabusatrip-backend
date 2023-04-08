Rails.application.routes.draw do
  scope "api" do
    scope "v1" do
      get "/test", to: "application#test"
    end
  end

  namespace "api" do
    namespace "v1" do
      resource :users, only: [:create, :destroy]
    end
  end
end
