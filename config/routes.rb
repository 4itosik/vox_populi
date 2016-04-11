Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :categories, only: [:index] do
    resources :themes, only: [:index]
  end

  resources :themes, only: [:new, :create]

  root 'pages#home'

  get '*path' => redirect('/')

end
