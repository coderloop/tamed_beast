  resources :forums, :topics, :posts

  resources :posts, :as => 'forum', :path_prefix => "/forums/:forum_id"

  resources :forums do
    resources :topics do
      resources :posts
    end
  end
