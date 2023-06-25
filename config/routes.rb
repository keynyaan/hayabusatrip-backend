Rails.application.routes.draw do
  scope "api" do
    scope "v1" do
      get "/test", to: "application#test"
    end
  end

  namespace "api" do
    namespace "v1" do
      resources :users, only: [:index, :show, :create, :update, :destroy], param: :uid do
        resources :trips, only: [:index, :show, :create, :update, :destroy], param: :trip_token do
          resources :spots, only: [:index, :show, :create, :update, :destroy], param: :id
          delete '/spots', to: 'spots#destroy'
        end
      end
      resources :trips, only: [:show], param: :trip_token do
        resources :spots, only: [:index], param: :id
      end
      resources :prefectures, only: [:index, :show]
      post '/s3/upload', to: 's3#upload'
    end
  end
end
