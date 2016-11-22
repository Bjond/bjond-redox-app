Rails.application.routes.draw do
  
  root 'bjond_registrations#index'

  get  '/redox/patient_admin/arrival' => 'patient_admin#verify_arrival'
  post '/redox/patient_admin/arrival' => 'patient_admin#arrival'

  get  '/redox/patient_admin/discharge' => 'patient_admin#verify_discharge'
  post '/redox/patient_admin/discharge' => 'patient_admin#discharge'

  get  '/redox/patient_admin/transfer' => 'patient_admin#verify_transfer'
  post '/redox/patient_admin/transfer' => 'patient_admin#transfer'

  get  '/redox/patient_admin/registration' => 'patient_admin#verify_registration'
  post '/redox/patient_admin/registration' => 'patient_admin#registration'

  get  '/redox/patient_admin/cancel' => 'patient_admin#verify_cancel'
  post '/redox/patient_admin/cancel' => 'patient_admin#cancel'

  get  '/redox/patient_admin/pre_admit' => 'patient_admin#verify_pre_admit'
  post '/redox/patient_admin/pre_admit' => 'patient_admin#pre_admit'

  get  '/redox/patient_admin/visit_update' => 'patient_admin#visit_update'
  post '/redox/patient_admin/visit_update' => 'patient_admin#visit_update'

  resources :redox_configurations
end
