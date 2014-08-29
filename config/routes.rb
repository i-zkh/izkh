Iz::Application.routes.draw do
 
  devise_for :users, controllers: { registrations: "registrations" }
  root to: 'landings#index'

  resources :about, only: :index

  resources :landings, only: :index

  resources :dashboard, only: :index
  resources :places do
    post :reg_create, on: :collection
  end
  resources :services do
    post :reg_create, on: :collection
    get :by_place, on: :member
  end

  resources :meters, only: [:create, :destroy, :index, :new]
  resources :metrics, only: [:create, :destroy, :new]
  
  resources :about, only: :index
  resources :feedback
  resources :user_feedbacks
  resources :vendors
  resources :notifications, only: [:create, :destroy, :update] do
    get 'by_vendor/:id' => 'notifications#index_by_vendor', on: :collection
  end

  resources :transactions do
    post 'pay', on: :collection
  end
  resources :widgets, only: [:create, :update, :index]

  get 'app' => 'app#index'
  post 'tutorial/off' => 'tutorials#off'
  get 'update_db' => 'update_table#update_db'
  get 'by_service_type' => 'vendors#by_service_type'
  get 'by_service_type_with_pay' => 'vendors#by_service_type_with_pay'
  get 'tariff_template' => 'services#tariff_template'
  get 'table_show' => 'transactions#table_show'
  get 'graph_show' => 'transactions#graph_show'
  get 'receipt' => 'transactions#receipt'
  get 'get_amount' => 'billing#get_amount'
  get 'terminal' => 'main#terminal'
  get 'commission' => 'main#commission'

  get 'sl_billing/:user_account' => 'billing#check_sl'
  get 'mb_check/:type/:user_account' => 'billing#check_mb'
  get 'mb_pay/:type/:user_account/:amount' => 'billing#pay_mb'

  # Service Type
  get 'api/1.0/servicetypes' => 'vendors#index'
  post 'api/1.0/servicetype' => 'vendors#create_types'

  # get 'send_pass_change' => 'update_table#send_pass_change'

  # Callback for Moneta
  get 'payment/success' => 'transactions#pay_success'
  get 'payment/fail' => 'transactions#pay_fail'

  # Callback for PO
  post 'api/1.0/payment_success' => 'transactions#success'
  post 'api/1.0/payment_fail' => 'transactions#fail'
  post 'api/1.0/vendors' => 'vendors#create'

  # Callback for Yandex
  get 'api/1.0/payment_success' => 'dashboard#index'
  get 'api/1.0/payment_fail' => 'dashboard#index'
  post 'api/1.0/payment_notify' => 'transactions#notify'
  post 'api/1.0/payment_check' => 'transactions#check'
  post 'api/1.0/yandex_success' => 'yandex#success'

  # TEST Callback for Yandex
  get 'api/1.0/payment_success/test' => 'dashboard#index'
  get 'api/1.0/payment_fail/test' => 'dashboard#index'
  post 'api/1.0/payment_notify/test' => 'transactions#notify'
  post 'api/1.0/payment_check/test' => 'transactions#check'

  # Callback for WebMoney
  post 'api/1.0/invoice_confirmation' => 'transactions#invoice_confirmation'
  get 'api/1.0/failed_payment' => 'transactions#failed_payment'
  post 'api/1.0/payment_notification' => 'transactions#payment_notification'

  # Api for terminals
  get 'api/1.0/terminal/vendors' => 'terminal#vendors'
  post 'api/1.0/terminal/payment/success' => 'terminal#success'

  # DELTA
  get 'delta_payment' => "delta_payment#pay"

  # Report
  get 'api/1.0/index_with_vendor_id' => 'report#index_with_vendor_id'
  get 'api/1.0/report_from_to' => 'report#index_from_to'
  get 'api/1.0/report_hourly' => 'report#index_hourly'
  get 'api/1.0/report_monthly' => 'report#index_monthly_by_vendor'
  get 'api/1.0/report_vendors' => 'report#vendors_with_transactions'

# Precinct
  get 'api/1.0/precinct/create' => 'precinct#parse_precinct'
  get 'widget_precinct/:id' => 'precinct#widget_precinct'

  get 'payment_form' => 'services#payment_form'
  get 'penalties/show' => 'penalties#show'
  get 'penalties' => 'penalties#index'

end