class PatientAdminController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:arrival, :discharge, :transfer, :registration, :cancel]

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
      if (!meta_info["CanceledEvent"].nil?)
        canceled_event = meta_info["CanceledEvent"]
      else
        canceled_event = nil
      end
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

    biological_sex = 'Unknown'
    if (sex == 'Male' || sex == 'Female' || sex == 'Other')
      biological_sex = sex
    end
    event_data = {
      :eventType => event_type,
      :diagnosesCodes => diagnoses_codes,
      :servicingFacility => facility,
      :sex => biological_sex,
      :dischargeDisposition => reason,
      :canceledEvent => canceled_event
    }
    puts event_data

    # Make web requests to Bjond on a separate thread
    BjondRegistration.all.each do |r|
      ap r
      rdxc = RedoxConfiguration.find_by_bjond_registration_id(r.id)
      event_data[:bjondPersonId]     = rdxc.sample_person_id
      event_data[:attendingProvider] = rdxc.sample_person_id
      puts event_data.to_json
      puts "firing now!"
      Thread.new do 
        begin
          BjondApi::fire_event(r, event_data.to_json, config.active_definition.integrationEvent.first.id)
        rescue StandardError => bang
          puts "Encountered an error when firing event associated with BjondRegistration with id: "
          puts r.id
          puts bang
        end
      end
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

  def discharge
    arrival()
  end

  def verify_discharge
    if request.headers['verification-token'] == ENV['REDOX_VERIFICATION_TOKEN']
      render :text => params[:challenge]
    else
      render :json => {
        :data => "Failed to verify token."
      }
    end
  end

  def transfer
    arrival()
  end

  def verify_transfer
    if request.headers['verification-token'] == ENV['REDOX_VERIFICATION_TOKEN']
      render :text => params[:challenge]
    else
      render :json => {
        :data => "Failed to verify token."
      }
    end
  end

  def registration
    arrival()
  end

  def verify_registration
    if request.headers['verification-token'] == ENV['REDOX_VERIFICATION_TOKEN']
      render :text => params[:challenge]
    else
      render :json => {
        :data => "Failed to verify token."
      }
    end
  end

  def cancel
    arrival()
  end

  def verify_cancel
    if request.headers['verification-token'] == ENV['REDOX_VERIFICATION_TOKEN']
      render :text => params[:challenge]
    else
      render :json => {
        :data => "Failed to verify token."
      }
    end
  end

end
