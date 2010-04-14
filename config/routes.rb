ActionController::Routing::Routes.draw do |map|
  map.resources :currencies, :payments

  map.root :controller => 'root'
end
