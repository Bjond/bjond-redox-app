Rails.application.routes.draw do
  
  root 'bjond_registrations#index'

  post '/redox/patient_admin/arrival' => 'patient_admin#arrival'

end
