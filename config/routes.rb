Rails.application.routes.draw do
  get 'bills/show'

  root to: 'bills#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
