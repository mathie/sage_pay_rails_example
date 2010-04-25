ActionController::Routing::Routes.draw do |map|
  map.resources :currencies, :countries
  map.resources :payments, :has_one => :sage_pay_transaction, :member => { :release => :put, :abort => :put, :refund => :put }
  map.resources :notifications, :only => [ :create ]
  map.root :controller => 'root'
end
