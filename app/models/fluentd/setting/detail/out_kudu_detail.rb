class Fluentd
  module Setting
    module Detail
      class OutKuduDetail < ActiveRecord::Base
        belongs_to :output
      end
    end
  end
end
