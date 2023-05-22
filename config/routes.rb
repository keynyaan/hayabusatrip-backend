Rails.application.routes.draw do
  scope "api" do
    scope "v1" do
      get "/test", to: "application#test"
    end
  end

  namespace "api" do
    namespace "v1" do
      resources :users, only: [:index, :show, :create, :update, :destroy], param: :uid
      resources :prefectures, only: [:index, :show]
      resources :trips, param: :trip_token, only: [:show, :create, :update, :destroy] do
        resources :spots, only: [:show, :create, :update, :destroy]
      end
      post '/s3/upload', to: 's3#upload'
    end
  end
end
