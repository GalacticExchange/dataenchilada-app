class Fluentd
  module Setting
    class OutWebhdfs < Output
      include Common

      relate_to_details

      def self.initial_params
        {
            host: 'namenode.your.cluster.local',
            port: '50070',
            path: "/path/on/hdfs/access.log.%Y%m%d_%H.#{Socket.gethostname}.log",
            flush_interval: '10s'
        }
      end

      def fluent_type
        'webhdfs'
      end

    end
  end
end
