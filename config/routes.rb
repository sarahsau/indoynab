Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'site#index'

  get '/faq', to: 'site#faq', as:'faq'
end
