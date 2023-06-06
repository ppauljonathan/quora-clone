Rails.application.routes.draw do
  get 'orders/new'
  get 'credit_packs/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  mount ActionCable.server => '/cable'

  root 'questions#index'

  resources :users do
    member do
      get :questions
      get :drafts
      get :answers
      get :comments
      get :followers
      get :followees
      post :follow
      post :unfollow
    end
  end

  resources :questions, param: :url_slug do
    get :comments, on: :member
  end

  resources :answers do
    get :comments, on: :member
  end

  resources :comments

  resources :reports, only: :create

  controller :credit_packs do
    get 'credit_packs' => :index
  end

  resources :orders, param: :number do
    member do
      get :cancel
      get :checkout, to: 'orders#show'
      get :success
      post :checkout
    end
  end

  resources :credit_transactions, only: %i[index show]

  resources :notifications, only: :index do
    post :read_all, on: :collection
  end

  controller :votes do
    post 'votes/upvote' => :upvote
    post 'votes/downvote' => :downvote
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
