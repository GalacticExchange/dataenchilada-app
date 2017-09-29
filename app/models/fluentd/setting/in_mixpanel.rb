class Fluentd
  module Setting
    class InMixpanel < InHttp
      def self.initial_params
        {
          bind: "0.0.0.0",
          port: 8888,
          body_size_limit: "32m",
          keepalive_timeout: "10s",
        }
      end
      #
      # def self.default_element
      #   params = self.initial_params.stringify_keys
      #   params['type'] = 'http_mixpanel'
      #   Fluent::Config::Element.new('source', '', params, [])
      # end

      def plugin_name
        "http_mixpanel"
      end
    end
  end
end
