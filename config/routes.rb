Rails.application.routes.draw do
  root 'static_pages#home'
  
  # StaticPages
  get	 '/about',   to: 'static_pages#about'
	get  '/help',    to: 'static_pages#help'
  get  '/home',    to: 'static_pages#home'
  get  '/contact', to: 'static_pages#contact'
end
