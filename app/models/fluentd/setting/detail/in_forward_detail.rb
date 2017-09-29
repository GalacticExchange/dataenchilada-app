class Fluentd
  module Setting
    module Detail
      class InForwardDetail < ActiveRecord::Base
        belongs_to :source

        validates :bind, presence: true
        validates :port, presence: true, uniqueness: true
      end
    end
  end
end
