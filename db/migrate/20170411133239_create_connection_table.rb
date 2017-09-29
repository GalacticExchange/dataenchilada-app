class CreateConnectionTable < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :name
      t.string :title
      t.integer :status
      t.integer :source_id

      t.timestamps
    end

    create_table :sources do |t|
      t.string :type

      t.timestamps
    end

    create_table :outputs do |t|
      t.string :type

      t.timestamp
    end

    create_table :in_twitter_details do |t|
      t.integer :source_id

      t.string :consumer_key
      t.string :consumer_secret
      t.string :access_token
      t.string :access_token_secret
      t.string :tag
      t.string :timeline
      t.string :keyword
      t.string :follow_ids
      t.string :locations
      t.string :lang
      t.string :output_format
      t.string :flatten_separator

      t.timestamp
    end

    create_table :in_http_details do |t|
      t.integer :source_id

      t.string :bind
      t.integer :port
      t.string :body_size_limit
      t.string :keepalive_timeout
      t.string :add_http_headers
      t.string :format
      t.string :log_level
      t.string :add_remote_addr
      
      t.timestamp
    end

    create_table :in_forward_details do |t|
      t.integer :source_id

      t.string :bind
      t.integer :port
      t.string :linger_timeout
      t.string :chunk_size_limit
      t.string :chunk_size_warn_limit
      t.string :log_level
      
      t.timestamp
    end

    create_table :in_sql_details do |t|
      t.integer :source_id

      t.string :host
      t.integer :port
      t.string :database
      t.string :adapter
      t.string :username
      t.string :password
      t.string :tag_prefix
      t.string :select_interval
      t.string :select_limit
      t.string :state_file
      t.string :table
      
      t.timestamp
    end

    create_table :in_tail_details do |t|
      t.integer :source_id

      t.string :path
      t.string :tag
      t.string :format
      t.string :regexp
      t.string :time_format
      t.string :rotate_wait
      t.string :pos_file
      t.string :read_from_head
      t.string :refresh_interval

      t.timestamp
    end

    create_table :out_kafka_details do |t|
      t.integer :output_id

      t.string :brokers
      t.string :buffer_type
      t.string :buffer_path
      t.string :flush_interval
      t.string :default_topic
      t.string :output_data_type
      t.string :compression_codec
      t.integer :max_send_retries
      t.integer :required_acks

      t.timestamp
    end

    create_table :out_kassandra_details do |t|
      t.integer :output_id

      t.string :hosts
      t.string :keyspace
      t.string :column_family
      t.string :ttl
      t.string :schema
      t.string :json_column
      t.string :pop_data_keys

      t.timestamp
    end

    create_table :out_elastic_details do |t|
      t.integer :output_id

      t.string :host
      t.integer :port
      t.string :index_name
      t.string :type_name

      t.timestamp
    end

    create_table :out_webhdfs_details do |t|
      t.integer :output_id

      t.string :host
      t.integer :port
      t.string :path
      t.string :flush_interval
      t.string :format

      t.timestamp
    end
    
    create_table :sync do |t|
      t.string :name
      t.integer :agent_id

      t.timestamp
    end
  end
end
