Rails.application.routes.draw do
  scope ':id' do
    resource :detainee_details, only: %i[ show update ], path: 'detainee-details'
    get :profile, to: 'profiles#show'
  end

  resource :escort, only: :create

  post '/', to: 'homepage#search', as: 'search'
  root to: 'homepage#show'
end
