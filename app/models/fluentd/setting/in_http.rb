class Fluentd
  module Setting
    class InHttp < Source

      relate_to_details
      # include ActiveModel::Model
      include Common

      KEYS = [
        :bind, :port, :body_size_limit, :keepalive_timeout, :add_http_headers, :format, :log_level, :add_remote_addr
      ].freeze

      # attr_accessor(*KEYS)

      def self.initial_params
        {
          bind: "0.0.0.0",
          port: 9880,
          body_size_limit: "32m",
          keepalive_timeout: "10s"
        }
      end

      def common_options
        [
          :bind, :port
        ]
      end

      def advanced_options
        [
          :body_size_limit, :keepalive_timeout, :add_http_headers, :format, :log_level, :add_remote_addr
        ]
      end

      def fields_descriptions
        {
            bind: "The bind address to listen to. Default Value = 0.0.0.0 (all addresses)",
            port: "The port to listen to. Default Value = 8888",
            body_size_limit: "The size limit of the POSTed element. Default Value = 32MB",
            keepalive_timeout: "The timeout limit for keeping the connection alive. Default Value = 10 seconds",
            add_http_headers: "Add HTTP_ prefix headers to the record. The default is false",
            add_remote_addr: "Add REMOTE_ADDR field to the record. The value of REMOTE_ADDR is the client’s address. The default is false",
            format: "The format of the HTTP body. The default is default. For more info read <a href='http://docs.fluentd.org/v0.12/articles/in_http' target='_blank'>documentaion</a>",
            log_level: "The log_level option allows the user to set different levels of logging for each plugin. The supported log levels are: fatal, error, warn, info, debug, and trace."
        }
      end

      def self.default_tag
        'type_expected_http_tag'
      end

      def plugin_name
        'http'
      end
    end
  end
end
