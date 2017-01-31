Rails.application.routes.draw do
  devise_for :users, skip: %i[ registrations ],
		controllers: { omniauth_callbacks: 'callbacks' }

  resources :detainees, only: %i[new create edit update show] do
    resources :moves, only: %i[new create]
  end
  resources :moves, only: %i[edit update]

  scope ':detainee_id' do
    resources :healthcare, only: %i[ show update ] do
      get :summary, on: :collection
      put :confirm, on: :collection
    end
    resources :risks, only: %i[ show update ], path: 'risk' do
      get :summary, on: :collection
      put :confirm, on: :collection
    end
    resource :offences, only: %i[ show update ]
    get  '/move/copy', to: 'copy_move#copy', as: 'copy_move'
    post '/move/copy', to: 'copy_move#create', as: 'copy_move_create'
  end

  scope ':move_id' do
    get :print, to: 'print#show'
  end

  post '/detainees/search', to: 'homepage#detainees'
  post '/moves/search', to: 'homepage#moves'
  root to: 'homepage#show'
end
