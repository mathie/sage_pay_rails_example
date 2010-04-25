ActionController::Routing::Routes.draw do |map|
  map.resources :currencies, :countries
  map.resources :payments, :has_one => :sage_pay_transaction
  map.resources :notifications, :only => [ :create ]
  map.root :controller => 'root'
end
