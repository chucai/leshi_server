Rails.application.routes.draw do
  match "/api/login.json" => "api/server#login"
  match "/api/live.json" => "api/server#save_live"
  match "/api/archived.json" => "api/server#save_archived"
end