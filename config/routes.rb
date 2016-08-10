Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do

      resources :users, only: :create

      scope "/auth", controller: :authentication do
        get '/logout' => :logout
        post '/login' => :login
      end
      
    end
  end
end
