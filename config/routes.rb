Chat::Application.routes.draw do

  resources :messages, except: :edit
  resources :users, except: :edit
  match "highest_user_id" => 'users#highest_id'
  match "highest_message_id" => 'messages#highest_id'
  root to: 'main#index'
  match "deck_shuffle" => "deck#shuffle"
  resources :users do
    member do
      get :shuffle
      get :new_deck
    end
  end
end
