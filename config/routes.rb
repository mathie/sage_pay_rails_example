ActionController::Routing::Routes.draw do |map|
  map.resources :currencies

  map.root :controller => 'root'
end
