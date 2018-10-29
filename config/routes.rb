Rails.application.routes.draw do
  get 'new', to: 'games#new', as: :new
  post 'score', to: 'games#score', as: :score
  get 'final', to: 'games#final', as: :final
  get 'badfinal', to: 'games#badfinal', as: :badfinal
  root to: 'games#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
