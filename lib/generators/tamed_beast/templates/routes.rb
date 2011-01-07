resources :posts, :name_prefix => 'all' do
  get :search, :on => :collection
end
resources :forums, :topics, :posts

%w(forum).each do |attr|
  resources :posts, :name_prefix => "#{attr}", :path_prefix => "/#{attr.pluralize}/:#{attr}_id"
end

resources :forums do
  resources :topics do
    resources :posts
  end
end
