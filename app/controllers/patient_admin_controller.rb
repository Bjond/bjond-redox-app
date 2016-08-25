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
    if (!meta_info.nil?)
      event_type = meta_info["EventType"]
    end
    if (!patient_info.nil?)
      diagnoses = patient_info["Diagnoses"]
      if (!diagnoses.nil? && diagnoses.count > 0)
        diagnoses_codes = diagnoses.map{ |d| d['Code'] }
      end

      sex = patient_info["Sex"]
    end
    if (!visit_info.nil?)
      reason = visit_info["Reason"]
      location = visit_info["Location"]
      if (!location.nil?)
        facility = location["Facility"]
      end
    end

    biological_sex = 'U'
    if (sex == 'Male')
      biological_sex = 'M'
    elsif (sex == 'Female')
      biological_sex = 'F'
    elsif (sex == 'Other')
      biological_sex = 'O'
    end
    event_data = {
      :eventType => event_type,
      :diagnosesCodes => diagnoses_codes,
      :servicingFacility => facility,
      :sex => biological_sex,
      :dischargeDisposition => reason
    }
    puts event_data
    BjondRegistration.all.each do |r|
      rdxc = RedoxConfiguration.find_by_bjond_registration_id(r.id)
      event_data[:bjondPersonId]     = rdxc.sample_person_id
      event_data[:attendingProvider] = rdxc.sample_person_id
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
