module Dataenchilada::Agents
  class Settings

    DIR_LOGS = "/var/log/fluentd"
    DIR_PIDS = "/etc/fluentd/pids"
    DIR_SUPERVISOR_CONF = "/etc/supervisor/conf.d"

    def self.pid_file(agent)
      #extra_options[:pid_file] || self.class.default_options[:pid_file]
      File.join(DIR_PIDS, "#{agent.conf_name}.pid")
    end

    def self.log_file(agent)
      #extra_options[:log_file] || self.class.default_options[:log_file]
      File.join(DIR_LOGS, "#{agent.conf_name}.log")
    end


    def self.config_file(agent)
      #extra_options[:config_file] || self.class.default_options[:config_file]
    end


    def self.sv_service_name(agent)
      "data_enchilada_agent_#{agent.conf_name}"
    end

    def self.sv_file(agent)
      sv_name = sv_service_name(agent)

      # DEBUG
      #"/tmp/#{sv_name}.conf"

      File.join(DIR_SUPERVISOR_CONF, "#{sv_name}.conf")


    end



    ### for tail

    def self.pos_file(agent)
      File.join(DIR_LOGS, "#{agent.conf_name}.pos")
    end




  end
end

