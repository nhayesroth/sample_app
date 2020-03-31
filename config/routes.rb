Rails.application.routes.draw do
  root 'application#hello'
  
  # StaticPages
  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/about'
end
