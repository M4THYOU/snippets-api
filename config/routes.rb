Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace 'api' do
    namespace 'v1' do
      resources :snippets
      resources :notes
      resources :lessons

      get 'types', to: 'types#index'
      get 'courses', to: 'courses#index'

      post 'users', to: 'users#create'

      get 'search', to: 'search_indices#index'

      # Authentication
      post 'authenticate', to: 'authentication#authenticate'
      get 'authenticate', to: 'authentication#verify'
    end
  end

end
