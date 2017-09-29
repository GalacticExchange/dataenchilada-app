class AddSqlTables < ActiveRecord::Migration
  def change
    create_table :in_sql_tables do |t|
      t.integer :source_id

      t.string :table
      t.string :tag
      t.string :update_column_val
      t.string :time_column
      t.string :primary_key

      t.timestamp
    end

    add_column :agents, :agent_type, :string
  end
end
