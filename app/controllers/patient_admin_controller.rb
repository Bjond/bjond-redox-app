class PatientAdminController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:arrival, :discharge, :transfer, :registration, :cancel, :pre_admit, :visit_update]

  require 'bjond-api'

  def arrival
    config = BjondApi::BjondAppConfig.instance
    # Handles payload from Redox, relays to Bjond Server Core in form of event.
    puts request.raw_post
    event_data = PatientAdminMessageParser.event_data_from_json(request.raw_post)
    puts event_data

    BjondRegistration.all.each do |r|
      ap r
      # rdxc = RedoxConfiguration.find_by_bjond_registration_id(r.id)
      configs = RedoxConfiguration.where(:bjond_registration_id => r.id)
      configs.each do |rdxc|
        if (rdxc.nil?)
          puts "No redox configuration found with registration with id #{r.id}. Skipping..."
          next
        elsif (rdxc.sample_person_id.nil?)
          puts "No person ID found for redox config with id #{rdxc.id}. You can add one as a tenant admin in the Bjond admin settings, on the Integration tab. Skipping..."
        else
          puts "Found redox configuration #{rdxc.id} with registration #{r.id}. Using sample person #{rdxc.sample_person_id}"
        end
        event_data[:bjondPersonId]     = rdxc.sample_person_id
        event_data[:attendingProvider] = rdxc.sample_person_id
        puts event_data.to_json
        puts "firing now!"

        ### Make web requests to Bjond on a separate thread to reduce callback time.
        Thread.new do
          begin
            BjondApi::fire_event_for_group(r, event_data.to_json, config.active_definition.integrationEvent.first.id, rdxc.group_id)
          rescue StandardError => bang
            puts "Encountered an error when firing event associated with BjondRegistration with id: "
            puts r.id
            puts bang
          end
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

  def visit_update
    arrival()
  end

  def verify_visit_update
    if request.headers['verification-token'] == ENV['REDOX_VERIFICATION_TOKEN']
      render :text => params[:challenge]
    else
      render :json => {
        :data => "Failed to verify token."
      }
    end
  end
  
  def pre_admit
    arrival()
  end

  def verify_pre_admit
    if request.headers['verification-token'] == ENV['REDOX_VERIFICATION_TOKEN']
      render :text => params[:challenge]
    else
      render :json => {
        :data => "Failed to verify token."
      }
    end
  end

end
