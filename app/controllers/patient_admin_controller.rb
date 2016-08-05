class PatientAdminController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:arrival]

  require 'bjond-api'
  
  def arrival
    config = BjondApi::BjondAppConfig.instance
    # Handles payload from Redox, relays to Bjond Server Core in form of event.
    puts request.raw_post
    parsed = JSON.parse(request.raw_post)
    meta_info = parsed["Meta"]
    visit_info = parsed["Visit"]
    patient_info = parsed["Patient"]
    visit_number = visit_info["VisitNumber"]
    event_data = {
      :visitNumber => visit_number
    }
    BjondRegistration.all.each do |r|
      rdxc = RedoxConfiguration.find_by_bjond_registration_id(r.id)
      event_data[:bjondPersonId] = rdxc.sample_person_id
      puts event_data.to_json
      BjondApi::fire_event(r, event_data.to_json, config.active_definition.integrationEvent.first.id)
    end
    render :json => {
      :status => 'OK'
    }
  end

  def verify_arrival
    if request.headers['verification-token'] == ENV['REDOX_VERIFICATION_TOKEN']
      render :text => params[:challenge]
    else
      render :json => {
        :data => "Failed to verify token."
      }
    end
  end
end
