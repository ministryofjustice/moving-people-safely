Rails.application.routes.draw do
  scope ':id' do
    resource :detainee_details, only: %i[ show update ], path: 'detainee-details'

    resource :move_information, only: %i[ show update ], path: 'move-info' do
      match '/',
        action: :add_destination, via: %i[ put patch ],
        constraints: -> (r) { r.params['commit'] =~ /Add/ }
    end

    get :profile, to: 'profiles#show'
  end

  resource :escort, only: :create

  post '/', to: 'homepage#search', as: 'search'
  root to: 'homepage#show'
end
