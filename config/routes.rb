Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'
  get 'home', to: 'welcome#home'
  devise_for :users do
    match 'new_user_session', to: '/devise/sessions#new', via: [:get]
    match 'user_session', to: '/devise/sessions#create', via: [:post]
    match 'new_user_registration', to: 'devise/registrations#new', via: [:get]
    match 'registration', to: 'devise/registrations#create', via: [:post]
    match 'destroy_user_session', to: 'devise/sessions#destroy', via: [:delete]
  end
end
