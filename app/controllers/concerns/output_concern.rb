module OutputConcern
  extend ActiveSupport::Concern

  included do
    before_action :login_required
    # before_action :find_fluentd
    helper_method :target_plugin_name, :plugin_setting_form_action_url
  end


  def show
    # @setting = target_class.new
    @agent = Agent.new
    @agent.title = 'My agent name'
    @agent.tag = target_class.default_tag
    @agent.source = target_class.new
    @agent.source.details = target_class::DETAILS_CLASS.new(target_class.initial_params)
    render "shared/settings/show"
  end

  def finish
    @agent = Agent.new(agent_params)
    source = target_class.new
    @agent.name = source.plugin_name
    @agent.agent_type = AgentType.find_by(name: 'fluentd')
    details = target_class::DETAILS_CLASS.new(setting_params)

    unless @agent.valid? && details.valid? && get_outputs.present?
      @agent.source = source
      @agent.source.details = details

      return render "shared/settings/show"
    end

    @agent.save!
    @agent.source = source
    @agent.source.details = details
    @agent.source.details.save!
    @agent.outputs = get_outputs

    # @fluentd.agent.config_append @setting.to_config
    # if @fluentd.agent.running?
    #   unless @fluentd.agent.restart
    #     @setting.errors.add(:base, @fluentd.agent.log.tail(1).first)
    #     @config = Fluentd::Setting::Config.new(@fluentd.config_file)
    #     @section_id = element_id(Fluent::Config::V1Parser.parse(@setting.to_config, @fluentd.config_file).elements.first)
    #     return render "shared/settings/edit"
    #   end
    # end
    redirect_to agents_path
  end

  def get_outputs
    outputs = []
    output_params.each do |key, flag|
      if flag == 'true'
        output = Output::OUTPUT_TYPES[key].constantize.new
        output.details = Output::OUTPUT_TYPES[key].constantize::DETAILS_CLASS.new(Output::OUTPUT_TYPES[key].constantize.initial_params)
        outputs << output
      end
    end
    outputs
  end

  private

  def output_params
    params.require('agent').require('outputs').permit(Output::OUTPUT_TYPES.keys)
  end

end
