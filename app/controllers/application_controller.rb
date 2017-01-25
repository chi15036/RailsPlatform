class ApplicationController < ActionController::Base
  # `python #{Rails.root}/lib/httpServer.py`
  protect_from_forgery unless: -> { request.format.json? }
end
