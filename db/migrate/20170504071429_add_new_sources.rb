class AddNewSources < ActiveRecord::Migration
  def change
    create_table :in_kafka_details do |t|
      t.integer :source_id

      t.string :brokers
      t.string :topics
      t.string :format
      t.string :message_key
      t.string :add_prefix
      t.string :add_suffix

      t.string :offset_zookeeper
      t.string :offset_zk_root_node

      t.string :max_bytes
      t.string :max_wait_time
      t.string :min_bytes

      t.timestamp
    end
  end
end
