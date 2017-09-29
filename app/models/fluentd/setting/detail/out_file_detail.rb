class Fluentd
  module Setting
    module Detail
      class OutFileDetail < ActiveRecord::Base
        belongs_to :output
      end
    end
  end
end
