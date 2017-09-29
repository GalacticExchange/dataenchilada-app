class Fluentd
  module Setting
    module Detail
      class OutKassandraDetail < ActiveRecord::Base
        belongs_to :output
      end
    end
  end
end
