module SettingEditConcern
  extend ActiveSupport::Concern

  included do
    helper_method :target_plugin_name, :plugin_setting_form_action_url, :plugin_setting_form_action_url_update
    skip_before_filter :verify_authenticity_token, :only => :edit
    before_action :set_config, :set_section, only: :update_config
  end

  def edit
    @section_id = edit_params['id']
    @setting = if target_class.respond_to? :create_from_config
                 target_class.create_from_config edit_params['content']
               else
                 setting_hash = Fluent::Config::V1Parser.parse(edit_params['content'], @fluentd.config_file).try(:elements).try(:first)
                 setting_hash.delete('type')
                 target_class.new setting_hash
               end
    render_edit_template
  end

  def update_config
    @setting = target_class.new(setting_params)
    unless @setting.valid?
      return render_edit_template
    end

    coming = Fluent::Config::V1Parser.parse(@setting.to_config, @fluentd.config_file)
    current = @section
    index = @config.elements.index current
    unless index
      render_404
      return
    end
    @config.elements[index] = coming.elements.first
    @config.write_to_file

    if @fluentd.agent.running?
      unless @fluentd.agent.restart
        @setting.errors.add(:base, @fluentd.agent.log.tail(1).first)
        @config = Fluentd::Setting::Config.new(@fluentd.config_file)
        @section_id = element_id(Fluent::Config::V1Parser.parse(@setting.to_config, @fluentd.config_file).elements.first)
        return render_edit_template
      end
    end

    redirect_to source_daemon_setting_path(@fluentd)
  end

  private

  def edit_params
    params.permit(:content, :id)
  end

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

  def plugin_setting_form_action_url_update(*args)
    send("update_config_daemon_setting_#{target_plugin_name}_path", *args)
  end

  def default_edit_template
    'shared/settings/edit'
  end

  def custom_edit_partial
    "#{self.class.new.send(:_prefixes).first}/edit"
  end

  def render_edit_template
    render custom_edit_partial rescue render default_edit_template
  end

  def target_plugin_name
    target_class.to_s.split("::").last.underscore
  end
end
