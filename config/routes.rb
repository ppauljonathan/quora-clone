Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root 'questions#index'

  resources :users, except: %i[new create] do
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

  resources :credit_logs, only: :index

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
