class Add < ActiveRecord::Migration
  def change
    add_column :sources, :agent_id, :integer
  end
end
