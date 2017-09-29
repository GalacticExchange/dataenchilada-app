class Fluentd
  module Setting
    class OutCassandra < Output
      include Common

      relate_to_details

      def self.initial_params
        {
            hosts: '127.0.0.1',
            keyspace: 'metrics',
            column_family: 'logs',
            ttl: 60,
            schema: 'true',
            pop_data_keys: 'true',
            json_column: 'json'
        }
      end

      def fluent_type
        'cassandra_driver'
      end


      def self.stream_field_name
        'schema'
      end

    end
  end
end
