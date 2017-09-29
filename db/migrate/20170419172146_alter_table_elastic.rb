class AlterTableElastic < ActiveRecord::Migration
  def change
    rename_table :out_elastic_details, :out_elasticsearch_details
  end
end
