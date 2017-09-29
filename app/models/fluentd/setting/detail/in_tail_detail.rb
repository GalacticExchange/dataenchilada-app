class Fluentd
  module Setting
    module Detail
      class InTailDetail < ActiveRecord::Base
        belongs_to :source

        validates :path, presence: true
      end
    end
  end
end
