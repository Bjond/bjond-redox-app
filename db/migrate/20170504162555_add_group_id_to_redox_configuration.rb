class AddGroupIdToRedoxConfiguration < ActiveRecord::Migration
  def change
    add_column :redox_configurations, :group_id, :string
  end
end
