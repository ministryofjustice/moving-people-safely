Rails.application.routes.draw do
  devise_for :users, skip: %i[ registrations ]

  scope ':escort_id' do
    resource :detainee_details, only: %i[ show update ], path: 'detainee-details'

    resource :move_information, only: %i[ show update ], path: 'move-info' do
      match '/',
        action: :add_destination, via: %i[ put patch ],
        constraints: -> (r) { r.params['commit'] =~ /Add/ }
    end

    resources :healthcare

    %i[
      to_self
      from_others
      violence
      harassments
      sex_offences
      non_association_markers
      security
      substance_misuse
      concealed_weapons
      arson
      communication
    ].each do |step|
      resource step, only: %i[ show update ], controller: :risks, step: step do
        match '/',
          action: :update_and_redirect_to_profile, via: %i[ put patch ],
          constraints: -> (r) { r.params['commit'] =~ /Save and view profile/ }
        match '/',
          action: :add_non_association_marker, via: %i[ put patch ],
          constraints: -> (r) { r.params['commit'] =~ /Add/ }
      end
    end

    get :profile, to: 'profiles#show'
  end

  resource :escort, only: :create

  post '/', to: 'homepage#search', as: 'search'
  root to: 'homepage#show'
end
