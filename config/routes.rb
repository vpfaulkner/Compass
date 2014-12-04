Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      get 'search' => 'legislators#search'
      get 'profile' => 'legislators#profile'
      get 'funding_timeline' => 'legislators#funding_timeline'
      get 'elections_timeline' => 'legislators#elections_timeline'
      get 'contributors_by_sector' => 'legislators#contributors_by_sector'
      get 'contributors_by_type' => 'legislators#contributors_by_type'
      get 'top_contributors' => 'legislators#top_contributors'
      get 'issue_ratings_dummy' => 'legislators#issue_ratings_dummy'

      get 'funding_score_by_category' => 'legislators#funding_score_by_category'
      get 'voting_score_by_issue' => 'legislators#voting_score_by_issue'
      get 'most_recent_votes' => 'legislators#most_recent_votes'
      get 'internal_get_norms' => 'legislators#internal_get_norms'
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
