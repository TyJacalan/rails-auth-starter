# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'pages#home'

  # Error routes
  get '/404', to: 'errors#not_found', via: :all
  get '/403', to: 'errors#forbidden', via: :all
  get '/422', to: 'errors#unprocessable', via: :all
  get '/500', to: 'errors#internal_server_error', via: :all
end
