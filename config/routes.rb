Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users, id: /\d+/, except: %i[new create]

  controller :registrations do
    get 'signup' => :new
    post 'signup' => :create
  end

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
  end

  controller :confirmations do
    get 'confirmation' => :verify
    post 'confirmation' => :resend
  end

  # Defines the root path route ("/")
  # root "articles#index"
end
