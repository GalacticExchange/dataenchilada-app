class AddTypeToAgent < ActiveRecord::Migration
  def self.up
    change_table :agents do |t|
      t.integer :agent_type_id
    end
  end

  def self.down
    remove_column :agents, :agent_type_id
  end

end
