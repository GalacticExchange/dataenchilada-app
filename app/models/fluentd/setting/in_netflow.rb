class Fluentd
  module Setting
    class InNetflow < Source

      relate_to_details
      # include ActiveModel::Model
      include Common

      KEYS = [
        :bind, :port, :switched_times_from_uptime
      ].freeze

      # attr_accessor(*KEYS)

      def self.initial_params
        {
          bind: "0.0.0.0",
          port: 5140,
          switched_times_from_uptime: "yes"
        }
      end

      def self.default_tag
        'type_expected_netflow_tag'
      end

      def common_options
        [
          :bind, :port
        ]
      end

      def advanced_options
        [
          :switched_times_from_uptime
        ]
      end

      def plugin_name
        'netflow'
      end
    end
  end
end
