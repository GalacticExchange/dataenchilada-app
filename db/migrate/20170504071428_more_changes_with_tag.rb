class MoreChangesWithTag < ActiveRecord::Migration
  def change
    add_column :agents, :tag, :string
    remove_column :sources, :tag
    remove_column :agents, :agent_type
  end
end
