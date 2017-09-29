class Fluentd
  module Setting
    module Detail
      class InTwitterDetail < ActiveRecord::Base
        belongs_to :source

        validates :consumer_key, presence: true, uniqueness: true
        validates :consumer_secret, presence: true, uniqueness: true
        validates :access_token, presence: true, uniqueness: true
        validates :access_token_secret, presence: true, uniqueness: true
        validates :timeline, presence: true
      end
    end
  end
end
