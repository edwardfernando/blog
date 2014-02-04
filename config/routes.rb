Blog::Application.routes.draw do
  
  get "welcome/index"
  root :to => "welcome#index"

  match 'login', to: 'welcome#login', via: [:get]
  match 'logout', to: 'welcome#destroy', via: [:get]

  resources :websites do
    collection do
      get 'kaskus_new'
      patch 'kaskus_new', :action => 'kaskus_create'
      get 'kaskus_load_thread'
      get 'kaskus_verify_token'
      get 'kaskus_fjb_thread_list'
    end

    member do
      get 'init', :action => 'kaskus_init_thread'
    end

    resources :testimonials
  end

  resources :posts do
    resources :comments
  end

  resources :profiles do
    member do
      get 'init', :action => 'profile_init'
      patch 'complete', :action => 'profile_complete'
    end

    collection do
      patch 'profile_update'
    end
  end
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

end
