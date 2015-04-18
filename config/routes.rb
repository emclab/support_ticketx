SupportTicketx::Engine.routes.draw do

  resources :issues

  root :to => 'issues#index'
end