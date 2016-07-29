class PatientAdminController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:arrival]

  def arrival
    # Handles payload from Redox, relays to Bjond Server Core in form of event.
    puts request.raw_post
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
