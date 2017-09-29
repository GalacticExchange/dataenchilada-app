class Fluentd::Settings::InNetflowController < ApplicationController
  include SettingConcern
  include SettingEditConcern

  private

  def target_class
    Fluentd::Setting::InNetflow
  end
end
