Rails.application.routes.draw do
  get 'tasklist/insert'
  post 'tasklist/insert'
  get 'tasklist/delete'
  get 'tasklist/display'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
end
