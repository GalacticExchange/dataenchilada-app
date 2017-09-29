class Fluentd
  module Setting
    class OutKafka < Output
      include Common

      relate_to_details

      def self.initial_params
        {
          zookeeper: "#{Fluentd::KAFKA_SERVER}:2181",
          # schema_registry: "http://#{Fluentd::KAFKA_SERVER}:8081",
          output_data_type: 'json'
        }
      end

    end
  end
end
