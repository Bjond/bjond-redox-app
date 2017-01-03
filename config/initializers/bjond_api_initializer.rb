require 'bjond-api'



config = BjondApi::BjondAppConfig.instance

config.group_configuration_schema = {
  :id => 'urn:jsonschema:com:bjond:persistence:bjondservice:GroupConfiguration',
  :title => 'bjond-redox-app-schema',
  :type  => 'object',
  :properties => {
    :api_key => {
      :type => 'string',
      :description => 'Redox API Key',
      :title => 'Redox API Key'
    },
    :secret => {
      :type => 'string',
      :description => 'Redox Source Secret',
      :title => 'Redox Source Secret'
    },
    :sample_person_id => {
      :type => 'string',
      :description => 'Bjönd Person ID. This can be any person ID in the tenant.',
      :title => 'Bjönd Patient ID'
    }
  },
  :required => ['sample_field']
}.to_json

config.encryption_key_name = 'REDOX_ENCRYPTION_KEY'

def config.configure_group(result, bjond_registration)
  redox_config = RedoxConfiguration.find_or_initialize_by(:bjond_registration_id => bjond_registration.id)
  if (redox_config.api_key != result['api_key'] || redox_config.secret != result['secret'] || redox_config.sample_person_id != result['sample_person_id'])
    redox_config.api_key = result['api_key'] 
    redox_config.secret = result['secret']
    redox_config.sample_person_id = result['sample_person_id']
    redox_config.save
  end
  return redox_config
end

def config.get_group_configuration(bjond_registration)
  redox_config = RedoxConfiguration.find_by_bjond_registration_id(bjond_registration.id)
  if (redox_config.nil?)
    puts 'No configuration has been saved yet.'
    return {:secret => '', :sample_person_id => '', :api_key => ''}
  else
    return redox_config
  end
end

### The integration app definition is sent to Bjond-Server core during registration.
config.active_definition = BjondApi::BjondAppDefinition.new.tap do |app_def|
  app_def.id           = 'e221951b-f0c5-4afe-b609-0325d533483e'
  app_def.author       = 'Bjönd, Inc.'
  app_def.name         = 'Bjönd Redox App'
  app_def.description  = 'Testing API functionality'
  app_def.iconURL      = 'http://cdn.slidesharecdn.com/profile-photo-RedoxEngine-96x96.jpg?cb=1468963688'
  app_def.integrationEvent = [
    BjondApi::BjondEvent.new.tap do |e|
      e.id = '3288feb8-7c20-490e-98a1-a86c9c17da87'
      e.jsonKey = 'admissionArrival'
      e.name = 'Redox Patient Admin (HL7)'
      e.description = 'An Arrival message is generated when a patient shows up for their visit or when a patient is admitted to the hospital.'
      e.serviceId = app_def.id
      e.fields = [
        BjondApi::BjondField.new.tap do |f|
          f.id = '0764d789-f231-4e65-b0d5-302cd60aaef3'
          f.jsonKey = 'bjondPersonId'
          f.name = 'Patient'
          f.description = 'The patient identifier'
          f.fieldType = 'Person'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'b23379b0-fc7e-4f5d-964b-f41b574d285a'
          f.jsonKey = 'eventType'
          f.name = 'Event Type'
          f.description = 'Either an admission or discharge event.'
          f.fieldType = 'MultipleChoice'
          f.options = [
            'Arrival',
            'Discharge',
            'Transfer',
            'Registration',
            'Cancel',
            'PreAdmit',
            'VisitUpdate'
          ]
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '5422679d-195f-45c9-9575-82d58fb6c4f2'
          f.jsonKey = 'canceledEvent'
          f.name = 'Canceled Event'
          f.description = 'This is the event type to be canceled.'
          f.fieldType = 'MultipleChoice'
          f.options = [
            'Arrival',
            'Discharge',
            'Transfer'
          ]
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '3728580f-855a-435d-a7d5-1cb956745c14'
          f.jsonKey = 'diagnosesCodes'
          f.name = 'Diagnoses Codes'
          f.description = 'This is the code relating to the diagnosis for the patient.'
          f.fieldType = 'MedicalCodeArray'
          f.codeType = 'ICD10'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '81dac31a-ea79-49c0-9e2c-cf19841d6559'
          f.jsonKey = 'servicingFacility'
          f.name = 'Servicing Facility'
          f.description = 'Name of the facility.'
          f.fieldType = 'String'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '51ee97dd-d6ae-44c2-aa83-b761029b818c'
          f.jsonKey = 'sex'
          f.name = 'Sex'
          f.description = 'Biological sex of the patient.'
          f.fieldType = 'MultipleChoice'
          f.options = [
            'Male',
            'Female',
            'Other',
            'Unknown'
          ]
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '847e24fe-fecd-47a8-af00-10b677ca858d'
          f.jsonKey = 'attendingProvider'
          f.name = 'Attending Provider'
          f.description = 'The attending provider person.'
          f.fieldType = 'Person'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '534dbe2f-c0d1-451b-ab88-aa3cc47f416c'
          f.jsonKey = 'dischargeDisposition'
          f.name = 'Discharge Disposition / Reason'
          f.description = 'Reason for visit.'
          f.fieldType = 'String'
          f.event = e.id
        end
        ###### Tasha wanted this removed for right now, but I think we'll want it back Issue #3095    ######
        # BjondApi::BjondField.new.tap do |f|
        #   f.id = 'ef9be5b0-0c52-4eca-92d4-1f034836858e'
        #   f.jsonKey = 'admissionTime'
        #   f.name = 'Admission Time'
        #   f.description = 'The date and time of admission.'
        #   f.fieldType = 'DateTime'
        #   f.event = e.id
        # end,
        # BjondApi::BjondField.new.tap do |f|
        #   f.id = 'f03b8671-d410-4cee-a157-aeadff1753ac'
        #   f.jsonKey = 'dischargeTime'
        #   f.name = 'Discharge Time'
        #   f.description = 'The date and time of discharge.'
        #   f.fieldType = 'DateTime'
        #   f.event = e.id
        # end,
      ]
    end
  ]
end
