Rails.application.routes.draw do
  devise_for :users, skip: %i[ registrations ]

  scope ':escort_id' do
    resource :detainee_details, only: %i[ show update ], path: 'detainee-details'
    resource :move_information, only: %i[ show update ], path: 'move-info'
    resources :healthcare

    get :profile, to: 'profiles#show'
  end

  resource :escort, only: :create

  post '/', to: 'homepage#search', as: 'search'
  root to: 'homepage#show'
end
