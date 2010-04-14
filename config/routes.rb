ActionController::Routing::Routes.draw do |map|
  map.resources :currencies, :countries
  map.resources :payments, :has_one => :sage_pay_transaction
  map.root :controller => 'root'
end
