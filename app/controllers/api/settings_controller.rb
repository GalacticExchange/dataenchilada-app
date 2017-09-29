class Api::SettingsController < ApplicationController
  include SettingsHelper
  before_action :login_required
  before_action :find_fluentd
  before_action :set_config
  before_action :set_section, only: [:show, :update, :destroy]
  helper_method :element_id

  def index
    current_types = @config.elements.map{|elm| elm['type']}
    default_listeners_keys_to_add = listeners_types_with_icons.keys.map(&:to_s) - current_types
    default_listeners_to_add = listeners_types_with_icons.select { |key, value| default_listeners_keys_to_add.include?(key.to_s) }.map{|key, value| value[:default_params]}
    @config_elements = @config.elements + default_listeners_to_add

    respond_to do |format|
      format.json
    end
  end

  def update
    coming = Fluent::Config::V1Parser.parse(params[:content], @fluentd.config_file)
    current = @section
    index = @config.elements.index current
    unless index
      render_404
      return
    end
    @config.elements[index] = coming.elements.first
    @config.write_to_file
    redirect_to api_setting_path(id: element_id(coming.elements.first))
  end

  def destroy
    unless @config.elements.index(@section)
      render_404
      return
    end
    @config.elements.delete @section
    @config.write_to_file
    head :no_content # 204
  end

  private

  def set_config
    @config = Fluentd::Setting::Config.new(@fluentd.config_file)
  end

  def set_section
    @section = @config.elements.find do |elm|
      element_id(elm) == params[:id]
    end
  end

  def element_id(element)
    index = @config.elements.index(element)
    "#{"%06d" % index}#{Digest::MD5.hexdigest(element.to_s)}"
  end

  def render_404
    render nothing: true, status: 404
  end
end
