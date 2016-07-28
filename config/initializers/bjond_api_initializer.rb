require 'bjond-api'

integration_app = BjondIntegration::BjondAppDefinition.new
integration_app.id           = 'e221951b-f0c5-4afe-b609-0325d533483e'
integration_app.author       = 'Bjond, Inc.'
integration_app.name         = 'Bjond Redox App'
integration_app.description  = 'Testing API functionality'
integration_app.iconURL      = ''
integration_app.configURL    = "http://#{Rails.application.config.action_controller.default_url_options[:host] || `hostname`}/bjond-app/services"
integration_app.rootEndpoint = "http://#{Rails.application.config.action_controller.default_url_options[:host] || `hostname`}/bjond-app/services"

config = BjondIntegration::BjondAppConfig.instance

config.active_definition = integration_app

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
  return {
    :api_key => redox_config.api_key,
    :secret => redox_config.secret
  }
end