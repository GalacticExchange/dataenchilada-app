class AlterOutKafkaTable < ActiveRecord::Migration
  def change
    add_column :out_kafka_details, :zookeeper, :string
  end
end
