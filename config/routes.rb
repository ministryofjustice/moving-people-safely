Rails.application.routes.draw do
  devise_for :users, skip: %i[ registrations ],
		controllers: { omniauth_callbacks: 'callbacks' }

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
    get  '/move/new', to: 'new_move#new', as: 'new_move'
    post '/move', to: 'new_move#create', as: 'create_move'
    get  '/move/copy', to: 'copy_move#copy', as: 'copy_move'
    post '/move/copy', to: 'copy_move#create', as: 'copy_move_create'
  end

  scope ':move_id' do
    get :profile, to: 'profiles#show'
    resource :move_information, only: %i[ show update ], path: 'move-info'
    get :print, to: 'print#show'
  end

  resource :detainee, only: [ :new, :create ], controller: :detainee_details

  post '/detainees/search', to: 'homepage#detainees'
  post '/moves/search', to: 'homepage#moves'
  root to: 'homepage#show'
end
