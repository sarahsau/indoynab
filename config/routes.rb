Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'converters#index'
  resources :converters, only: [:create, :show]
  get '/faq', to: 'converters#faq', as:'faq'
  # post '/uploads', to: 'converter#create'
end
