ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users
  map.resource :session
  map.resources :comments
  
  map.root :controller => "home"
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  map.namespace :admin do |admin|
    admin.resources :categories
    admin.resources :channels
    admin.resources :data_values
    admin.resources :articles
    admin.resources :settings 
    admin.resources :users
    admin.resources :data_fields
    admin.resources :comments, :member => {:publish => :get, :spam => :post, :not_spam => :post}
  end
  
  map.connect 'admin', :controller => "Admin::Admin"
  
  # These routes should be the lowest priority if you are going to 
  # add additional routes (for example: articles by date).
  
  map.channel_view ':renders_with.:format', :controller => :channel, :action => :index
  map.render_view ':renders_with.:format', :controller => :channel, :action => :index
  map.category_view ':channel_slug/categories/:category_slug.:format', :controller => :channel, :action => :category_by_slug
  map.article_view ':renders_with/:article_slug', :controller => :channel, :action => :article_by_slug
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
