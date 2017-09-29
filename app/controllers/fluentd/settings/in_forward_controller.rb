class Fluentd::Settings::InForwardController < ApplicationController
  include SettingConcern
  include SettingEditConcern

  private

  def target_class
    Fluentd::Setting::InForward
  end
end
