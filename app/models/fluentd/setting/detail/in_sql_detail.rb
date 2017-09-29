class Fluentd
  module Setting
    module Detail
      class InSqlDetail < ActiveRecord::Base
        belongs_to :source

        validates :host, presence: true
        validates :database, presence: true
        validates :adapter, presence: true
        validates :username, presence: true
        validates :password, presence: true
        validates :state_file, presence: true
      end
    end
  end
end
