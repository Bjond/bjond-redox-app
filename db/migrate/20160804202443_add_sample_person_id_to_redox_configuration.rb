class AddSamplePersonIdToRedoxConfiguration < ActiveRecord::Migration
  def change
    add_column :redox_configurations, :sample_person_id, :string
  end
end
