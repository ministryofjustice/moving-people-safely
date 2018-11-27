Rails.application.routes.draw do
  get '/auth/:provider/callback', to: 'sessions#create'
  resource :session, only: %i[ new destroy ]

  get :ping, to: 'heartbeat#ping', format: :json
  get :healthcheck, to: 'heartbeat#healthcheck',  as: 'healthcheck', format: :json

  namespace :admin do
    resource :movements, only: %i[new show]
  end

  resource :court, only: %i[show] do
    get :select
    post :change
  end

  resources :escorts, only: %i[show new create] do
    get :confirm_cancel, on: :member
    put :cancel, on: :member
    get :confirm_approve, on: :member
    put :approve, on: :member
    resource :detainee
    resource :move
    resource :healthcare, except: :destroy do
      get :intro, on: :collection
      put :confirm, on: :collection
    end
    resource :risks, except: :destroy, path: 'risk' do
      get :automation, on: :member
      get :intro, on: :collection
      put :confirm, on: :collection
    end
    resource :offences, only: %i[show update]
    resource :print, only: %i[new show], controller: 'escorts/print'
  end

  resources :feedbacks, only: %i[new create]
  post '/escorts/search', to: 'homepage#escorts'

  get '/search', to: 'search#new'
  post '/search', to: 'search#show'

  get '/select_police_station', to: 'homepage#select_police_station'
  post '/set_police_station', to: 'homepage#set_police_station'
  get '/help', to: 'homepage#help'
  root to: 'homepage#show'
end
