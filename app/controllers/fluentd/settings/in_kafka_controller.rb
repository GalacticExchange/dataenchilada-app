class Fluentd::Settings::InKafkaController < ApplicationController
  include SettingConcern
  include SettingEditConcern

  private

  def target_class
    Fluentd::Setting::InKafka
  end
end
