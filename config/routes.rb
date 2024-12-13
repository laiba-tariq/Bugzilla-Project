# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :user_projects, only: %i[new create destroy]

  resources :projects do
    resources :bugs
  end

  namespace :api do
    namespace :v1 do
      resources :projects do
        resources :bugs
      end
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
