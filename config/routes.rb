ActionController::Routing::Routes.draw do |map|
  map.resources :currencies, :payments, :countries

  map.root :controller => 'root'
end
