Rails.application.routes.draw do
  resources :products
  get 'demo_partials/new'
  get 'demo_partials/edit'
  scope "(:locale)",locale: /en|vi/ do
    get 'static_pages/home'
    get 'static_pages/help'
  end
 
end
