Rails.application.routes.draw do
  # get 'home/index'
  # devise_for :users
  get 'task/insert'
  post 'task/insert'
  get 'task/display'
  get 'task/delete'
  post 'task/delete'
  get 'task/edit'
  post 'task/edit'
  get 'schedule/insert'
  post 'schedule/insert'
  # get 'schedule/display'
  get 'api/schedule/view',    to: 'schedule#get_schedules_as_json'
  post 'api/schedule/delete', to: 'schedule#delete_schedule_via_api'
  post 'api/schedule/edit',   to: 'schedule#edit_schedule_via_api'
  get 'schedule/delete'
  post 'schedule/delete'
  get 'schedule/edit'
  post 'schedule/edit'
  get 'tasklist/insert'
  post 'tasklist/insert'
  get 'tasklist/delete'
  post 'tasklist/delete'
  get 'tasklist/display'
  get '/kiyaku', to: 'static#kiyaku'
  get '/privacy', to: 'static#privacy'
  get '/about', to: 'static#about'

  get '/login', to: 'sessions#login'
  get '/logout', to: 'sessions#logout'
  
  get 'home/index'  
  devise_for :users, controllers: {
      omniauth_callbacks: "users/omniauth_callbacks"
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'task#insert'
end
