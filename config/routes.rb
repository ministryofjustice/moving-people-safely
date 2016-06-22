Rails.application.routes.draw do
  devise_for :users, skip: %i[ registrations ]

  scope ':id' do
    resource :detainee_details, only: %i[ show update ], path: 'detainee-details'

    resource :move_information, only: %i[ show update ], path: 'move-info' do
      match '/',
        action: :add_destination, via: %i[ put patch ],
        constraints: -> (r) { r.params['commit'] =~ /Add/ }
    end

    %i[ physical mental social allergies needs transport contact ].each do |step|
      resource step, only: %i[ show update ], controller: :healthcare, step: step do
        match '/',
          action: :update_and_redirect_to_profile, via: %i[ put patch ],
          constraints: -> (r) { r.params['commit'] =~ /Save and view profile/ }
        match '/',
          action: :add_medication, via: %i[ put patch ],
          constraints: -> (r) { r.params['commit'] =~ /Add/ }
      end
    end

    %i[ to_self from_others violence ].each do |step|
      resource step, only: %i[ show update ], controller: :risks, step: step do
        match '/',
          action: :update_and_redirect_to_profile, via: %i[ put patch ],
          constraints: -> (r) { r.params['commit'] =~ /Save and view profile/ }
      end
    end

    get :profile, to: 'profiles#show'
  end

  resource :escort, only: :create

  post '/', to: 'homepage#search', as: 'search'
  root to: 'homepage#show'
end
