class AddNewPutputs < ActiveRecord::Migration
  def change
    create_table :out_forward_details do |t|
      t.integer :source_id

      t.string :brokers
      t.string :topics
      t.string :format
      t.string :phi_threshold
      t.string :add_prefix
      t.string :hard_timeout

      t.string :server_name
      t.string :server_host
      t.string :server_port
      t.string :server_weight

      t.timestamp
    end

    create_table :out_file_details do |t|
      t.integer :source_id

      t.string :path
      t.string :time_slice_format
      t.string :time_slice_wait
      t.string :time_format
      t.string :compress

      t.timestamp
    end

    create_table :out_kudu_details do |t|
      t.integer :source_id

      t.string :master_addresses
      t.string :table_name
      t.string :producer
      t.string :batchSize
      t.string :timeout_millis
      t.string :ignore_duplicate_rows

      t.timestamp
    end
  end
end
