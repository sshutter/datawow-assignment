Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'posts/all_posts'
      namespace :user do
        resources :posts
        post "sign_in", to: "sessions#sign_in"
        post "register", to: "sessions#register"
        delete "sign_out", to: "sessions#sign_out"
        get "me", to: "sessions#me"
      end
      get "posts", to: "posts#all_posts"
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

end
