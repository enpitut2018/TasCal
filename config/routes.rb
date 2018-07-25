Rails.application.routes.draw do
  get 'schedule/insert'
  get 'schedule/display'
  get 'schedule/delete'
  get 'tasklist/insert'
  post 'tasklist/insert'
  get 'tasklist/delete'
  post 'tasklist/delete'
  get 'tasklist/display'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'tasklist#insert'
end
