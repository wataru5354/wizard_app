Rails.application.routes.draw do
  get 'home/index'
  # deviseのコントローラーを作成する必要があるので必ずrails g devise:controllerコマンドを使うこと！
  devise_for :users,controllers:{
    # urlの指定は必須
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get 'addresses', to: 'users/registrations#new_address'
    post 'addresses', to: 'users/registrations#create_address'
  end
  root to:'home#index'
end
