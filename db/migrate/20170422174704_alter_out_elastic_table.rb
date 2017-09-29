class AlterOutElasticTable < ActiveRecord::Migration
  def change
    add_column :out_elasticsearch_details, :logstash_format, :boolean
    add_column :out_elasticsearch_details, :include_tag_key, :boolean
    add_column :out_elasticsearch_details, :utc_index, :boolean
  end
end
