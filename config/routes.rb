Rails.application.routes.draw do
  scope "(:locale)", locale: /en|sk/ do
    root to: 'tournaments#index'

    devise_for :users

    get 'static_pages/about'

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
