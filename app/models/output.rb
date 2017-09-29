class Output < ActiveRecord::Base
  def self.relate_to_details
    class_eval <<-EOF
      has_one :details, :class_name => "Fluentd::Setting::Detail::#{self.name.split('::').last}Detail", :foreign_key => :output_id
      accepts_nested_attributes_for :details
      default_scope -> { includes(:details) }
      
      DETAILS_CLASS = "Fluentd::Setting::Detail::#{self.name.split('::').last}Detail".constantize

      belongs_to :agent
    EOF
  end

  belongs_to :engine, class_name: '::Agent', foreign_key: :agent_id

  OUTPUT_TYPES = {
      'kafka' => 'Fluentd::Setting::OutKafka',
      'elasticsearch' => 'Fluentd::Setting::OutElasticsearch',
      'cassandra' => 'Fluentd::Setting::OutCassandra',
      'webhdfs' => 'Fluentd::Setting::OutWebhdfs',
      'forward' => 'Fluentd::Setting::OutForward',
      'file' => 'Fluentd::Setting::OutFile',
      'kudu' => 'Fluentd::Setting::OutKudu',
  }

  TYPES_BASE = {
      'Fluentd::Setting::OutKafka' => 'kafka',
      'Fluentd::Setting::OutCassandra' => 'cassandra',
      'Fluentd::Setting::OutElasticsearch' => 'elasticsearch',
      'Fluentd::Setting::OutWebhdfs' => 'webhdfs',
      'Fluentd::Setting::OutForward' => 'forward',
      'Fluentd::Setting::OutFile' => 'file',
      'Fluentd::Setting::OutKudu' => 'kudu'
  }

  STREAM_FIELD_NAMES = {
      'kafka' => 'default_topic',
      'elasticsearch' => 'index_name',
      'cassandra' => 'schema',
      'webhdfs' => 'path',
      'forward' => 'server',
      'file' => 'path',
      'kudu' => 'table_name',
  }

  def output_type_name
    return TYPES_BASE[self.type]
  end

end
