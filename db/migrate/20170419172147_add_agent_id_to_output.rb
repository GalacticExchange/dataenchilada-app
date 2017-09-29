class AddAgentIdToOutput < ActiveRecord::Migration
  def change
    add_column :outputs, :agent_id, :integer
  end
end
