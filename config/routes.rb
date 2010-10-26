ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users
  map.resource :session
  map.resources :comments
  
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
  
  map.root :controller => :channel, :action => :home
  map.jeweli ':renders_with/*parts.:format', :controller => :channel, :action => :index
  
  map.channel_view ':renders_with.:format', :controller => :channel, :action => :index
  map.render_view ':renders_with.:format', :controller => :channel, :action => :index
  map.category_view ':channel_slug/:category_slug.:format', :controller => :channel, :action => :category_by_slug
  map.article_view ':renders_with/:article_slug', :controller => :channel, :action => :article_by_slug

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
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
  
end
