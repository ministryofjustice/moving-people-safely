Rails.application.routes.draw do
  scope ':id' do
    resource :detainee_details, only: %i[ show ], path: 'detainee-details'
  end

  resource :escort, only: :create

  post '/', to: 'homepage#search', as: 'search'
  root to: 'homepage#show'
end
