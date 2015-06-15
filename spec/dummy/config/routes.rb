Rails.application.routes.draw do

  mount Authentify::Engine => "/authentify"
  mount Commonx::Engine => '/commonx'
  mount SupportTicketx::Engine => "/support_ticketx"


  root :to => "authentify/sessions#new"
  get '/signin',  :to => 'authentify/sessions#new'
  get '/signout', :to => 'authentify/sessions#destroy'
  get '/user_menus', :to => 'user_menus#index'

end
