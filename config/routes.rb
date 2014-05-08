Iz::Application.routes.draw do
 
  devise_for :users, controllers: { registrations: "registrations" }
  root to: 'dashboard#index'

  resources :dashboard, only: :index
  resources :places do
    post :reg_create, on: :collection
  end
  resources :services do
    post :reg_create, on: :collection
    get :by_place, on: :member
  end
  
  resources :about, only: :index
  resources :feedback

  resources :transactions do
    post 'pay', on: :collection
  end
  resources :widgets, only: [:create, :update, :index]

  get 'app' => 'app#index'
  post 'tutorial/off' => 'tutorial#off'
  get 'update_db' => 'update_table#update_db'
  get 'by_service_type' => 'vendors#by_service_type'
  get 'by_service_type_with_pay' => 'vendors#by_service_type_with_pay'

  # Callback for PO
  post 'api/1.0/payment_success' => 'transactions#success'
  post 'api/1.0/payment_fail' => 'transactions#fail'

  # Callback for Yandex
  get 'api/1.0/payment_success' => 'main#index'
  get 'api/1.0/payment_fail' => 'main#index'
  post 'api/1.0/payment_notify' => 'transactions#notify'
  post 'api/1.0/payment_check' => 'transactions#check'

  # TEST Callback for Yandex
  get 'api/1.0/payment_success/test' => 'main#index'
  get 'api/1.0/payment_fail/test' => 'main#index'
  post 'api/1.0/payment_notify/test' => 'transactions#notify'
  post 'api/1.0/payment_check/test' => 'transactions#check'

  # Callback for WebMoney
  post 'api/1.0/invoice_confirmation' => 'transactions#invoice_confirmation'
  get 'api/1.0/failed_payment' => 'transactions#failed_payment'
  post 'api/1.0/payment_notification' => 'transactions#payment_notification'

  # Api for terminals
  get 'api/1.0/terminal/vendors' => 'terminal#vendors'
  post 'api/1.0/terminal/payment/success' => 'terminal#success'

end
