#ActionController::Routing::Routes.draw do |map|
Rails.application.routes.draw do
  resources :posts, :name_prefix => 'all' do
    get :search, :on => :collection
  end
	resources :forums, :topics, :posts, :monitorship

  %w(forum).each do |attr|
    resources :posts, :name_prefix => "#{attr}", :path_prefix => "/#{attr.pluralize}/:#{attr}_id"
  end
  
  resources :forums do
    resources :topics do
      resources :posts
      resource :monitorship, :controller => :monitorships
    end
  end
end
