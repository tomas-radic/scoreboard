Rails.application.routes.draw do
  scope "(:locale)" do
    devise_for :users
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    root to: 'tournaments#index'

    resources :tournaments do
      resources :courts do
        post :reorder_matches, on: :member
        resources :matches, only: [:new] do
          post :reorder, on: :collection
        end
      end
      resources :matches do
        get :edit_score, on: :member
        post :update_score, on: :member
      end
      get :refresh_score, on: :member
    end
  end
end
