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
    # visit_number = visit_info["VisitNumber"]
    if (!meta_info.nil?)
      event_type = meta_info["EventType"]
    end
    if (!patient_info.nil?)
      diagnoses = patient_info["Diagnoses"]
      if (!diagnoses.nil? && diagnoses.count > 0)
        ## TODO: Need to handle array field (instead of using first result).
        diagnosis_code = diagnoses.first["Code"]
      end
    end
    if (!visit_info.nil?)
      location = visit_info["Location"]
      if (!location.nil?)
        facility = location["Facility"]
      end
    end
    event_data = {
      # :visitNumber => visit_number,
      :eventType => event_type,
      :diagnosisCode => diagnosis_code,
      :facility => facility
    }
    puts event_data
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
