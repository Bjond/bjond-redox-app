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
    }
  },
  :required => ['sample_field']
}.to_json

config.encryption_key_name = 'REDOX_ENCRYPTION_KEY'

def config.configure_group(result, bjond_registration)
  redox_config = RedoxConfiguration.find_or_initialize_by(:bjond_registration_id => bjond_registration.id)
  if (redox_config.api_key != result['api_key'] || redox_config.secret != result['secret'])
    redox_config.api_key = result['api_key'] 
    redox_config.secret = result['secret']
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
    return { :api_key => redox_config.api_key, :secret => redox_config.secret }
  end
end

### The integration app definition is sent to Bjond-Server core during registration.
config.active_definition = BjondApi::BjondAppDefinition.new.tap do |app_def|
  app_def.id           = 'e221951b-f0c5-4afe-b609-0325d533483e'
  app_def.author       = 'Bjond, Inc.'
  app_def.name         = 'Bjond Redox App'
  app_def.description  = 'Testing API functionality'
  app_def.iconURL      = ''
  app_def.configURL    = "http://#{Rails.application.config.action_controller.default_url_options ? Rails.application.config.action_controller.default_url_options[:host] : nil || `hostname`}/bjond-app/services"
  app_def.rootEndpoint = "http://#{Rails.application.config.action_controller.default_url_options ? Rails.application.config.action_controller.default_url_options[:host] : nil || `hostname`}/bjond-app/services"
  app_def.integrationEvent = [
    BjondApi::BjondEvent.new.tap do |e|
      e.id = '3288feb8-7c20-490e-98a1-a86c9c17da87'
      e.jsonKey = 'admissionArrival'
      e.name = 'Admission Arrival'
      e.description = 'An Arrival message is generated when a patient shows up for their visit or when a patient is admitted to the hospital.'
      e.serviceId = app_def.id
      e.fields = [
        BjondApi::BjondField.new.tap do |f|
          f.id = 'c6bab6ed-df86-42b1-a06d-73e436491491'
          f.jsonKey = 'visitNumber'
          f.name = 'Vist Number'
          f.description = 'Vist Number'
          f.fieldType = 'Vist Number'
          f.id = e.id
        end
      ]
    end
  ]
end
