Rails.application.routes.draw do

  mount SupportTicketx::Engine => '/support_ticketx'
  mount Authentify::Engine => "/authentify"
  mount Commonx::Engine => '/commonx'

  resource :session

  root :to => "authentify::sessions#new"
  match '/signin',  :to => 'authentify::sessions#new'
  match '/signout', :to => 'authentify::sessions#destroy'
  match '/user_menus', :to => 'user_menus#index'
  match '/view_handler', :to => 'authentify::application#view_handler'

end
