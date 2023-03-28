Rails.application.routes.draw do
  resources :books do
    resources :comments, only: %i(create update)
  end
  resources :reports do
    resources :comments, only: %i(create update)
  end
  resources :comments, only: %i(edit destroy)
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users
  root to: 'books#index'
  resources :users, only: %i(index show)
end
