Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'tournaments#index'

  resources :tournaments do
    resources :courts do
      resources :matches, only: [:new]
    end
    resources :matches do
      get :edit_score, on: :member
      post :update_score, on: :member
    end
    get :refresh_score, on: :member
  end
end
