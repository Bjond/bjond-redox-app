Rails.application.routes.draw do
  post 'patient_admin/arrival'

  root 'bjond_registrations#index'
end
