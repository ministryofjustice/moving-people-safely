Rails.application.routes.draw do
  devise_for :users, skip: %i[ registrations ]

  scope ':escort_id' do
    resource :detainee_details, only: %i[ show update ], path: 'detainee-details'
    resource :move_information, only: %i[ show update ], path: 'move-info'
    resources :healthcare, only: %i[ show update ] do
      get :summary, on: :collection
    end
    resources :risks, only: %i[ show update ], path: 'risk' do
      get :summary, on: :collection
    end
    resource :offences, only: %i[ show update ]
    get :print, to: 'print#show'
    get :profile, to: 'profiles#show'
  end

  resource :escort, only: :create

  post '/search', to: 'homepage#search', as: 'search'
  post '/date', to: 'homepage#date', as: 'date_picker'
  root to: 'homepage#show'
end
