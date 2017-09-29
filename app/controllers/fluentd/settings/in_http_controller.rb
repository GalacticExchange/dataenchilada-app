class Fluentd::Settings::InHttpController < ApplicationController
  include SettingConcern
  include SettingEditConcern

  private

  def target_class
    Fluentd::Setting::InHttp
  end
end
