class Fluentd
  module Setting
    class InForward < Source

      relate_to_details
      # include ActiveModel::Model
      include Common

      KEYS = [
        :bind, :port, :linger_timeout, :chunk_size_limit, :chunk_size_warn_limit, :log_level
      ].freeze
      #
      # attr_accessor(*KEYS)

      def self.initial_params
        {
          bind: "0.0.0.0",
          port: 24224,
          linger_timeout: 0,
          chunk_size_limit: nil,
          chunk_size_warn_limit: nil,
          log_level: "info",
        }
      end

      def common_options
        [
          :bind, :port
        ]
      end

      def advanced_options
        [
          :linger_timeout, :chunk_size_limit, :chunk_size_warn_limit, :log_level
        ]
      end

      def self.default_tag
        'type_expected_forward_tag'
      end

      def plugin_name
        "forward"
      end
    end
  end
end
