class Fluentd
  module Setting
    module Detail
      class OutKafkaDetail < ActiveRecord::Base
        belongs_to :output
      end
    end
  end
end
