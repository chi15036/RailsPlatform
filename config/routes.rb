Rails.application.routes.draw do
  namespace :v1, defaults: {format: :json} do
    resource :entities
  end
end
