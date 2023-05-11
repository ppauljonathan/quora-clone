Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users, id: /\d+/, except: %i[new create] do
    collection do
      get 'email_verification'
      post 'validate_verification_token'
    end
  end

  controller :users do
    get 'signup'
    post 'signup' => :create
  end

  # Defines the root path route ("/")
  # root "articles#index"
end
