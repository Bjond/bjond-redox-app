# This migration comes from bjond_api_engine (originally 20160801184749)
class RenameRegistrationIdinBjondServiceToBjondRegistrationId < ActiveRecord::Migration
  def change
    rename_column :bjond_services, :registration_id, :bjond_registration_id
  end
end
