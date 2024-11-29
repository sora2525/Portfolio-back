Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "health_check", to: "health_check#index"
      mount_devise_token_auth_for "User", at: "auth"
      resources :tasks
      resources :tags
      resources :chats, only: [:index, :create, :destroy]
      delete '/chats', to: 'chats#destroy_all'
    end
  end
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end