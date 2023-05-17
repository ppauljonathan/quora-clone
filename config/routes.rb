Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root 'questions#index'

  resources :users, id: /\d+/

  resources :questions, param: :url_slug do
    collection do
      get 'search'
    end
  end

  controller :registrations do
    get 'signup' => :new
    post 'signup' => :create
  end

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  controller :confirmations do
    get 'confirmation' => :verify
    post 'confirmation' => :resend
  end

  controller :passwords do
    get 'reset_password' => :new
    post 'reset_password' => :create
    get 'reset_password/edit' => :edit
    patch 'reset_password' => :update
  end

  get 'topics/search'

  # Defines the root path route ("/")
  # root "articles#index"
end
