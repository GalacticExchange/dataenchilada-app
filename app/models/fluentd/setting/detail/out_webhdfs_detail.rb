class Fluentd
  module Setting
    module Detail
      class OutWebhdfsDetail < ActiveRecord::Base
        belongs_to :output
      end
    end
  end
end
