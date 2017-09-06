Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'dashboards#index'

  resources :dashboards
  resources :calendars, only: :index
  resources :sprints
  resources :meetings
  resources :absences
  namespace :team do
    resources :members
  end

  PagesController::PAGES.each do |page|
    get "pages/#{page}", to: "pages##{page}", as: "#{page}_page"
  end
end
