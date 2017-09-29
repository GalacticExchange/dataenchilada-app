class Fluentd::Settings::InTwitterController < ApplicationController
  include SettingConcern
  include SettingEditConcern

  private

  def target_class
    Fluentd::Setting::InTwitter
  end
end
