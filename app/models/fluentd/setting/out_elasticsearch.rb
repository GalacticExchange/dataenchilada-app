class Fluentd
  module Setting
    class OutElasticsearch < Output
      include Common

      relate_to_details

      KEYS = [
        # :match,
        :host, :port, :index_name, :type_name,
        :logstash_format, :logstash_prefix, :logstash_dateformat, :utc_index,
        :hosts, :request_timeout, :include_tag_key
      ].freeze
      #
      # attr_accessor(*KEYS)

      booleans :logstash_format, :utc_index, :include_tag_key

      # validates :match, presence: true

      def self.initial_params
        {
          host: "127.0.0.1",
          port: 9200,
          index_name: "via_fluentd",
          type_name: "via_fluentd",
          logstash_format: true,
          include_tag_key: false,
          utc_index: true,
        }
      end

      def common_options
        [
          :match, :host, :port, :logstash_format,
          :index_name, :type_name,
        ]
      end

      def advanced_options
        [
          :hosts, :logstash_prefix, :logstash_dateformat,
          :utc_index, :request_timeout, :include_tag_key,
        ]
      end

      def fluent_type
        'elasticsearch'
      end
    end
  end
end
