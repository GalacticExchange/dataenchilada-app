class Fluentd::Settings::InMixpanelController < ApplicationController
  include SettingConcern
  include SettingEditConcern

  private

  def target_class
    Fluentd::Setting::InMixpanel
  end
end
