Rails.application.routes.draw do
  devise_for :users, skip: %i[ registrations ]

  scope ':detainee_id' do
    resource :detainee_details, only: %i[ show update ], path: 'detainee-details'
    resources :healthcare, only: %i[ show update ] do
      get :summary, on: :collection
      put :confirm, on: :collection
    end
    resources :risks, only: %i[ show update ], path: 'risk' do
      get :summary, on: :collection
      put :confirm, on: :collection
    end
    resource :offences, only: %i[ show update ]
    resource :move, only: %i[ new copy ], path: 'move', controller: 'move_information'
    get '/move/copy', to: 'move_information#copy', as: 'copy_move'
    post 'move/create', to: 'move_information#create', as: 'create_move'
  end

  scope ':move_id' do
    get :profile, to: 'profiles#show'
    resource :move_information, only: %i[ show update ], path: 'move-info'
    get :print, to: 'print#show'
  end

  resource :escort, only: :create

  post '/search', to: 'homepage#search', as: 'search'
  post '/date', to: 'homepage#date', as: 'date_picker'
  root to: 'homepage#show'
end
