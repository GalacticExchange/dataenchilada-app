class DebugController < BaseController
  before_action :_before_action

  def _before_action
    raise 'Forbidden' if ['production'].include? Rails.env
  end


  def generate_config
    @agent = Agent.find(1)

    @res = Dataenchilada::Agents::Configurator.generate_config(@agent)




  end
end
