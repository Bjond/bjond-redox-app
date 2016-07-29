# This migration comes from bjond_api_engine (originally 20160726195312)
class CreateBjondRegistrations < ActiveRecord::Migration
  def change
    create_table :bjond_registrations do |t|
      t.string :server
      t.string :encryptionKey

      t.timestamps null: false
    end
  end
end
