Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "health_check", to: "health_check#index"
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        passwords: 'api/v1/auth/passwords'
      }
      namespace :auth do
        post 'google_login', to: 'google_login#create'
        post 'line_login', to: 'line_login#create'
        post 'line_link', to: 'line_link#link'
      end
      resources :tasks
      resources :tags
      resources :diaries do
        collection do
          get 'public_index', to: 'diaries#public_index'
        end
      end
      resources :chats, only: [:index, :create, :destroy]
      delete '/chats', to: 'chats#destroy_all'
      post '/line_webhook', to: 'line_webhook#callback'
    end
  end
end
