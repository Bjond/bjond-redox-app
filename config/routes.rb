Rails.application.routes.draw do
  
  root 'bjond_registrations#index'

  get  '/redox/patient_admin/arrival' => 'patient_admin#verify_arrival'
  post '/redox/patient_admin/arrival' => 'patient_admin#arrival'
  resources :redox_configurations
end
