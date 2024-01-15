# frozen_string_literal: true

# require_relative '../app/controllers/projects/bugs_controller'
Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :projects do
    get :add_user, on: :member
    get :remove_user, on: :member
    resources :bugs do
      patch :start_working, on: :member
      patch :mark_complete, on: :member
      patch :assign_to_dev, on: :member, as: :assign_to_dev, to: 'bugs#assign_to_dev'
    end
  end
  get '/qa_projects', to: 'projects#qa_projects', as: :qa_projects
  get '/assigned_bugs', to: 'bugs#assigned_bugs', as: :assigned_bugs

  get 'up' => 'rails/health#show', as: :rails_health_check
end
