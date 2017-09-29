class AddIndexNameToAgents < ActiveRecord::Migration
  def self.up
    add_index :agents, :name
  end

  def self.down
    remove_index :agents, :name
  end
end
