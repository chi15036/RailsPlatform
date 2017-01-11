Rails.application.routes.draw do
  root to: 'v1/entities#index'
  namespace :v1, defaults: {format: :json} do
    resource :entities
  end
end
