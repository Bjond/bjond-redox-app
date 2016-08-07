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
      :description => 'Bjond Person ID. This can be any person ID in the tenant.',
      :title => 'Bjond Patient ID'
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
    return {}
  else
    return redox_config
  end
end

### The integration app definition is sent to Bjond-Server core during registration.
config.active_definition = BjondApi::BjondAppDefinition.new.tap do |app_def|
  app_def.id           = 'e221951b-f0c5-4afe-b609-0325d533483e'
  app_def.author       = 'Bjond, Inc.'
  app_def.name         = 'Bjond Redox App'
  app_def.description  = 'Testing API functionality'
  app_def.iconURL      = 'http://cdn.slidesharecdn.com/profile-photo-RedoxEngine-96x96.jpg?cb=1468963688'
  app_def.integrationEvent = [
    BjondApi::BjondEvent.new.tap do |e|
      e.id = '3288feb8-7c20-490e-98a1-a86c9c17da87'
      e.jsonKey = 'admissionArrival'
      e.name = 'Admission / Discharge'
      e.description = 'An Arrival / discharge is generated when a patient shows up for their visit or when a patient is admitted to or discharged from the hospital.'
      e.serviceId = app_def.id
      e.fields = [
        BjondApi::BjondField.new.tap do |f|
          f.id = 'c6bab6ed-df86-42b1-a06d-73e436491491'
          f.jsonKey = 'visitNumber'
          f.name = 'Vist Number'
          f.description = 'Vist Number'
          f.fieldType = 'String'
          f.id = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '2091de2e-dcf9-461a-b66c-ea4c01081f9c'
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
            'Admission',
            'Discharge'
          ]
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '3728580f-855a-435d-a7d5-1cb956745c14'
          f.jsonKey = 'diagnosisCode'
          f.name = 'Diagnosis Code'
          f.description = 'This is the code relating to the diagnosis for the patient.'
          f.fieldType = 'String'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '81dac31a-ea79-49c0-9e2c-cf19841d6559'
          f.jsonKey = 'facility'
          f.name = 'Facility'
          f.description = 'Name of the facility.'
          f.fieldType = 'String'
          f.event = e.id
        end
      ]
    end
  ]
end
