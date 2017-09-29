class CreateTableAgentTypes < ActiveRecord::Migration
  def self.up
    create_table :agent_types do |t|
      t.string :name
      t.string :title
      t.integer :status
    end
  end

  def self.down
    drop_table :agent_types
  end


end
