class PatientAdminMessageParser

  def self.event_data_from_json(raw_json)
    parsed = JSON.parse(raw_json)
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

      sex = patient_info["Demographics"]["Sex"] || patient_info["Sex"]
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
  end
end