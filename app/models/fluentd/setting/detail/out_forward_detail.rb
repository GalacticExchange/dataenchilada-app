class Fluentd
  module Setting
    module Detail
      class OutForwardDetail < ActiveRecord::Base
        belongs_to :output
      end
    end
  end
end
