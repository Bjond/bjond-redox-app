class PatientAdminController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:arrival]

  def arrival
    # Handles payload from Redox, relays to Bjond Server Core in form of event.
    puts request.raw_post
    render :json => {
      :status => 'OK'
    }
  end
end
