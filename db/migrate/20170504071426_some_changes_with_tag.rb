class SomeChangesWithTag < ActiveRecord::Migration
  def change
    add_column :sources, :tag, :string
    remove_column :in_sql_tables, :tag
    remove_column :in_sql_details, :tag_prefix
    remove_column :in_twitter_details, :tag
    remove_column :in_tail_details, :tag
    remove_column :in_netflow_details, :tag
  end
end
