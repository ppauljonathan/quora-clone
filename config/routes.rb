Rails.application.routes.draw do
  get 'orders/new'
  get 'credit_packs/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

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

  resources :abuse_reports, only: :create

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

  scope controller: :votes, path: 'votes' do
    post 'upvote'
    post 'downvote'
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

  get 'credit_logs' => 'credit_logs#index'

  # Defines the root path route ("/")
  # root "articles#index"
end
