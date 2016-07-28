Rails.application.routes.draw do
  get 'patient_admin/arrival'

  root 'bjond_registrations#index'
end
