class Fluentd
  module Setting
    module Detail
      class InKafkaDetail < ActiveRecord::Base
        belongs_to :source

        validates :brokers, presence: true, uniqueness: true
        validates :topics, presence: true
        validates :format, presence: true
      end
    end
  end
end
