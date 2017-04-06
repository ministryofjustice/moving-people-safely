Rails.application.routes.draw do
  get '/auth/:provider/callback', to: 'sessions#create'
  resource :session, only: %i[ new destroy ]

  resources :escorts, only: %i[new create show] do
    resource :detainee do
      resource :image, only: %i[show], controller: 'detainees/images', constraints: { format: 'jpg' }
    end
    resource :move
    resource :healthcare, only: %i[show update] do
      get :summary, on: :collection
      put :confirm, on: :collection
    end
    resource :risks, only: %i[show update], path: 'risk' do
      get :summary, on: :collection
      put :confirm, on: :collection
    end
    resource :offences, only: %i[show update]
    resource :print, only: %i[show], controller: 'escorts/print'
  end

  post '/detainees/search', to: 'homepage#detainees'
  post '/moves/search', to: 'homepage#moves'
  root to: 'homepage#show'
end
