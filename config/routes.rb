Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  mount ActionCable.server => '/cable'

  root 'questions#index'

  resources :users, except: %i[new create index] do
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

  resources :answers, except: :index do
    get :comments, on: :member
  end

  resources :comments, except: %i[index show]

  resources :abuse_reports, only: :create

  resources :orders, only: %i[create show], param: :number do
    member do
      get :cancel
      get :checkout, to: 'orders#show'
      get :success
      post :checkout
      post :update_cart
      delete :remove_line_item
      post :clear_cart
    end
  end

  resources :credit_transactions, only: %i[index show]
  resources :credit_logs, only: :index

  resources :credit_packs, only: :index
  resources :credit_logs, only: :index

  resources :notifications, only: :index do
    post :read_all, on: :collection
  end

  namespace :admin do
    resources :users, only: %i[index] do
      member do
        post :enable
        post :disable
      end
    end

    resources :questions, param: :url_slug, only: %i[index] do
      post :unpublish, on: :member
    end
  end

  namespace :api do
    get 'topics/:topic' => 'topics#index'
    get 'feed' => 'questions#index'
  end

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

  # Defines the root path route ("/")
  # root "articles#index"
end
