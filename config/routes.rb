Rails.application.routes.draw do

  devise_for :users
  root to: "questions#index"

  resources :questions do
    member do
      post "vote_up"
      post "vote_down"
      delete "cancel_vote"
    end
    resources :comments, :defaults => { :commentable => 'question' }
    resources :answers, only: [:create, :update, :destroy, :vote_up, :vote_down, :cancel_vote] do

    post "best", on: :member
    post "cancel_best", on: :member

    resources :attachments, only: [:destroy]
    end

    resources :attachments, only: [:destroy]
  end

  resources :answers, only: [:destroy]
  resources :answers do
    resources :comments, :defaults => { :commentable => 'answer' }
    member do
      post "vote_up"
      post "vote_down"
      delete "cancel_vote"
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
