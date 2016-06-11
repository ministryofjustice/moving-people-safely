Rails.application.routes.draw do
  post '/', to: 'homepage#search', as: 'search'
  root to: 'homepage#show'
end
