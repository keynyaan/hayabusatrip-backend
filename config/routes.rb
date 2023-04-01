Rails.application.routes.draw do
  scope "api" do
    scope "v1" do
      get "/test", to: "application#test"
    end
  end
end
