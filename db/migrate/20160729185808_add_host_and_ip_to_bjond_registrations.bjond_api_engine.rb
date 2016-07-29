# This migration comes from bjond_api_engine (originally 20160727144938)
class AddHostAndIpToBjondRegistrations < ActiveRecord::Migration
  def change
    add_column :bjond_registrations, :host, :string
    add_column :bjond_registrations, :ip, :string
  end
end
