Jewelicms::Application.routes.draw do |map|
  
  match "/logout", :to => "sessions#destroy", :as => :logout
  match "/login", :to => "sessions#new", :as => :login
  resource :session
  resources :comments
  
  namespace :admin do 
    match '/', :to => "admin#index"
    resources :categories
    resources :channels
    resources :data_values
    resources :articles
    resources :settings 
    resources :users
    resources :data_fields do
      post :update_positions, :on => :collection
    end
    resources :comments do
      member do 
        get 'publish'
        post 'spam'
        post 'not_spam'
      end
    end
  end
    
  root :to => "channel#home" 
  match ':renders_with/(*parts).:format', :to => "channel#index", :as => :jeweli, :constraints => {:format => /rss|html|js|xml|json/}
  # We have to have two routes here because we are using globbing
  # and it will swallow the :format param if the :format param is optional.
  # See for details: https://rails.lighthouseapp.com/projects/8994/tickets/1939-optimal-formatted-routes-breaks-format-requirements
  match ':renders_with/(*parts)', :to => "channel#index", :as => :jeweli, :constraints => {:format => /rss|html|js|xml|json/}

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
