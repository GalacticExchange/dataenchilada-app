class Fluentd
  module Setting
    module Detail
      class OutElasticsearchDetail < ActiveRecord::Base
        belongs_to :output

        validates :host, presence: true
        validates :port, presence: true
        validates :index_name, presence: true
        validates :type_name, presence: true
      end
    end
  end
end
