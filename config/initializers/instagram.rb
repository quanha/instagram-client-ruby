require "instagram"

Instagram.configure do |config|
  config.client_id = "c013631f09334e7594dcf7b87ae167f3"
  config.client_secret = "13c1721798574ff8949110caf46845f6"
end

CALLBACK_URL = "http://localhost:3000/session/callback"
