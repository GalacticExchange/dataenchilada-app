# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170504071459) do

  create_table "agent_types", force: :cascade do |t|
    t.string  "name",   limit: 255
    t.string  "title",  limit: 255
    t.integer "status", limit: 4
  end

  create_table "agents", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "title",         limit: 255
    t.integer  "status",        limit: 1
    t.integer  "source_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agent_type_id", limit: 4
    t.string   "tag",           limit: 255
  end

  add_index "agents", ["name"], name: "index_agents_on_name", using: :btree

  create_table "in_forward_details", force: :cascade do |t|
    t.integer "source_id",             limit: 4
    t.string  "bind",                  limit: 255
    t.integer "port",                  limit: 4
    t.string  "linger_timeout",        limit: 255
    t.string  "chunk_size_limit",      limit: 255
    t.string  "chunk_size_warn_limit", limit: 255
    t.string  "log_level",             limit: 255
  end

  create_table "in_http_details", force: :cascade do |t|
    t.integer "source_id",         limit: 4
    t.string  "bind",              limit: 255
    t.integer "port",              limit: 4
    t.string  "body_size_limit",   limit: 255
    t.string  "keepalive_timeout", limit: 255
    t.string  "add_http_headers",  limit: 255
    t.string  "format",            limit: 255
    t.string  "log_level",         limit: 255
    t.string  "add_remote_addr",   limit: 255
  end

  create_table "in_kafka_details", force: :cascade do |t|
    t.integer "source_id",           limit: 4
    t.string  "brokers",             limit: 255
    t.string  "topics",              limit: 255
    t.string  "format",              limit: 255
    t.string  "message_key",         limit: 255
    t.string  "add_prefix",          limit: 255
    t.string  "add_suffix",          limit: 255
    t.string  "offset_zookeeper",    limit: 255
    t.string  "offset_zk_root_node", limit: 255
    t.string  "max_bytes",           limit: 255
    t.string  "max_wait_time",       limit: 255
    t.string  "min_bytes",           limit: 255
  end

  create_table "in_netflow_details", force: :cascade do |t|
    t.integer "source_id",                  limit: 4
    t.string  "bind",                       limit: 255
    t.integer "port",                       limit: 4
    t.string  "switched_times_from_uptime", limit: 255
  end

  create_table "in_sql_details", force: :cascade do |t|
    t.integer "source_id",       limit: 4
    t.string  "host",            limit: 255
    t.integer "port",            limit: 4
    t.string  "database",        limit: 255
    t.string  "adapter",         limit: 255
    t.string  "username",        limit: 255
    t.string  "password",        limit: 255
    t.string  "select_interval", limit: 255
    t.string  "select_limit",    limit: 255
    t.string  "state_file",      limit: 255
    t.string  "table",           limit: 255
  end

  create_table "in_sql_tables", force: :cascade do |t|
    t.integer "source_id",         limit: 4
    t.string  "table",             limit: 255
    t.string  "update_column_val", limit: 255
    t.string  "time_column",       limit: 255
    t.string  "primary_key",       limit: 255
  end

  create_table "in_tail_details", force: :cascade do |t|
    t.integer "source_id",        limit: 4
    t.string  "path",             limit: 255
    t.string  "format",           limit: 255
    t.string  "regexp",           limit: 255
    t.string  "time_format",      limit: 255
    t.string  "rotate_wait",      limit: 255
    t.string  "pos_file",         limit: 255
    t.string  "read_from_head",   limit: 255
    t.string  "refresh_interval", limit: 255
  end

  create_table "in_twitter_details", force: :cascade do |t|
    t.integer "source_id",           limit: 4
    t.string  "consumer_key",        limit: 255
    t.string  "consumer_secret",     limit: 255
    t.string  "access_token",        limit: 255
    t.string  "access_token_secret", limit: 255
    t.string  "timeline",            limit: 255
    t.string  "keyword",             limit: 255
    t.string  "follow_ids",          limit: 255
    t.string  "locations",           limit: 255
    t.string  "lang",                limit: 255
    t.string  "output_format",       limit: 255
    t.string  "flatten_separator",   limit: 255
  end

  create_table "out_elasticsearch_details", force: :cascade do |t|
    t.integer "output_id",       limit: 4
    t.string  "host",            limit: 255
    t.integer "port",            limit: 4
    t.string  "index_name",      limit: 255
    t.string  "type_name",       limit: 255
    t.boolean "logstash_format"
    t.boolean "include_tag_key"
    t.boolean "utc_index"
  end

  create_table "out_file_details", force: :cascade do |t|
    t.integer "source_id",         limit: 4
    t.string  "path",              limit: 255
    t.string  "time_slice_format", limit: 255
    t.string  "time_slice_wait",   limit: 255
    t.string  "time_format",       limit: 255
    t.string  "compress",          limit: 255
  end

  create_table "out_forward_details", force: :cascade do |t|
    t.integer "source_id",     limit: 4
    t.string  "brokers",       limit: 255
    t.string  "topics",        limit: 255
    t.string  "format",        limit: 255
    t.string  "phi_threshold", limit: 255
    t.string  "add_prefix",    limit: 255
    t.string  "hard_timeout",  limit: 255
    t.string  "server_name",   limit: 255
    t.string  "server_host",   limit: 255
    t.string  "server_port",   limit: 255
    t.string  "server_weight", limit: 255
  end

  create_table "out_kafka_details", force: :cascade do |t|
    t.integer "output_id",         limit: 4
    t.string  "brokers",           limit: 255
    t.string  "buffer_type",       limit: 255
    t.string  "buffer_path",       limit: 255
    t.string  "flush_interval",    limit: 255
    t.string  "default_topic",     limit: 255
    t.string  "output_data_type",  limit: 255
    t.string  "compression_codec", limit: 255
    t.integer "max_send_retries",  limit: 4
    t.integer "required_acks",     limit: 4
    t.string  "zookeeper",         limit: 255
  end

  create_table "out_kassandra_details", force: :cascade do |t|
    t.integer "output_id",     limit: 4
    t.string  "hosts",         limit: 255
    t.string  "keyspace",      limit: 255
    t.string  "column_family", limit: 255
    t.string  "ttl",           limit: 255
    t.string  "schema",        limit: 255
    t.string  "json_column",   limit: 255
    t.string  "pop_data_keys", limit: 255
  end

  create_table "out_kudu_details", force: :cascade do |t|
    t.integer "source_id",             limit: 4
    t.string  "master_addresses",      limit: 255
    t.string  "table_name",            limit: 255
    t.string  "producer",              limit: 255
    t.string  "batchSize",             limit: 255
    t.string  "timeout_millis",        limit: 255
    t.string  "ignore_duplicate_rows", limit: 255
  end

  create_table "out_webhdfs_details", force: :cascade do |t|
    t.integer "output_id",      limit: 4
    t.string  "host",           limit: 255
    t.integer "port",           limit: 4
    t.string  "path",           limit: 255
    t.string  "flush_interval", limit: 255
    t.string  "format",         limit: 255
  end

  create_table "outputs", force: :cascade do |t|
    t.string  "type",     limit: 255
    t.integer "agent_id", limit: 4
  end

  create_table "sources", force: :cascade do |t|
    t.string   "type",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agent_id",   limit: 4
  end

  create_table "sync", force: :cascade do |t|
    t.string  "name",     limit: 255
    t.integer "agent_id", limit: 4
  end

end
