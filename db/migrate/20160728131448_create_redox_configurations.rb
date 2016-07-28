class CreateRedoxConfigurations < ActiveRecord::Migration
  def change
    create_table :redox_configurations do |t|
      t.string :api_key
      t.string :secret
      t.string :bjond_registration_id

      t.timestamps null: false
    end
  end
end
