#resources :posts, :name_prefix => 'all' do
  #get :search, :on => :collection
#end
resources :forums, :topics, :posts

resources :posts, :name_prefix => 'forum', :path_prefix => "/forums/:forum_id"

resources :forums do
  resources :topics do
    resources :posts
  end
end
