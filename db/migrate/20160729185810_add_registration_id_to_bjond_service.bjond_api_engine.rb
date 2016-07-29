# This migration comes from bjond_api_engine (originally 20160727194217)
class AddRegistrationIdToBjondService < ActiveRecord::Migration
  def change
    add_column :bjond_services, :registration_id, :string
  end
end
