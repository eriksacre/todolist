Todolist::Application.routes.draw do
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create]
  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :tasks, only: [:index, :show, :create, :destroy, :update, :edit] do
    collection do
      get 'completed'
    end
    member do
      post 'complete'
      post 'reopen'
      post 'reposition'
    end
  end
  
  resources :activities, only: [:index]
  
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :tasks, except: [:new, :edit]
      resources :me, only: [:index]
    end
  end
  
  root 'tasks#index'
end
