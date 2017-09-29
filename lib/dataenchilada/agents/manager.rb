module Dataenchilada::Agents
  class Manager

    COMMANDS = ['run', 'start', 'stop', 'restart']

    ###
    def self.logger
      Rails.logger
    end

    ###
    def self.do_command(agent, cmd)
      unless COMMANDS.include?(cmd)
        return false
      end

      #
      return send(cmd.to_sym, agent)
    end


    def self.run(agent)
      # install
      install(agent)

      # start
      start(agent)

    end


    def self.start(agent)
      agent.begin_start!

      # start with supervisor
      sv_name = ::Dataenchilada::Agents::Settings::sv_service_name(agent)
      cmd = "supervisorctl start #{sv_name}"
      res = Dataenchilada::System::Commands::exec(cmd)

      agent.finish_start!

      return true
    end

    def self.stop(agent)
      agent.begin_stop!

      # with supervisor
      sv_name = ::Dataenchilada::Agents::Settings::sv_service_name(agent)
      cmd = "supervisorctl stop #{sv_name}"
      res = Dataenchilada::System::Commands::exec(cmd)


      agent.finish_stop!

      return true
    end

    def self.restart(agent)
      agent.begin_restart!

      # with supervisor
      sv_name = ::Dataenchilada::Agents::Settings::sv_service_name(agent)
      cmd = "supervisorctl stop #{sv_name}"
      res = Dataenchilada::System::Commands::exec(cmd)

      cmd = "supervisorctl start #{sv_name}"
      res = Dataenchilada::System::Commands::exec(cmd)



      agent.finish_restart!

      return true
    end



    ### install

    def self.install(agent)
      # generate config
      res_config = Dataenchilada::Agents::Configurator.generate_config(agent)

      #agent.set_installing!

      # check config
      begin
        cmd = cmd_check_config(agent)
        res_config = Dataenchilada::System::Commands::exec(cmd)

        logger.error "Run cmd: #{cmd}. Output: #{res_config[1]}"
      rescue => e
        logger.error "Error in config"
        logger.error "Error in config: #{res_config.try(:[],1)}, cmd: #{cmd}"
        logger.error e.message

        raise 'Error in config'
        #return false
      end

      logger.error "Config Ok. Agent: #{agent.conf_name}"



      # install with supervisor
      install_service_supervisor(agent)


      #
      agent.finish_install!


      true
    end


    def self.install_service_supervisor(agent)
      require 'erb'
      s_tpl = File.read(File.join(Rails.root, "data/templates/#{agent.agent_type.name}/supervisor/supervisor.conf.erb"))

      cmd = build_cmd_run(agent)
      tpl_vars = OpenStruct.new(agent: agent, cmd: cmd)

      result = ERB.new(s_tpl).result(tpl_vars.instance_eval { binding })

      sv_filename = ::Dataenchilada::Agents::Settings::sv_file(agent)

      logger.debug "Try to write to file: #{sv_filename}"
      logger.debug "Content: #{result}"

      File.open(sv_filename,'w') do |f|
        f.write(result)
      end

      logger.info "Created sv file: #{sv_filename}"

      # reload supervisor
      begin
        #cmd = "service supervisor stop; service supervisor start"
        cmd = "supervisorctl reread; supervisorctl update"
        res = Dataenchilada::System::Commands::exec(cmd, true)
        logger.debug "Restart supervisor. Output: #{res[1]}"
      rescue => e
        logger.error "Cannot restart supervisor"
      end


      true
    end


    ### helpers - operations with agent

    def self.build_cmd_run(agent, opts={})
      #
      # config_file_path = Dataenchilada::Agents::Configurator.config_filename(agent)

      #
      #opts = {config_file: agent.config_path, log_file: agent.log_path}
      opts_args = options_to_argv(agent, opts)

      # run
      %Q(fluentd #{opts_args})
    end


    def self.cmd_check_config(agent, opts={})
      #
      config_file_path = Dataenchilada::Agents::Configurator.config_filename(agent)

      #
      opts = {config_file: config_file_path}
      opts_args = options_to_argv(agent, opts)

      # run
      %Q(fluentd --dry-run #{opts_args})
    end



    def self.options_to_argv(agent, opts = {})

      lib = ::Dataenchilada::Agents::Settings

      argv = ""


      argv << " -c #{agent.config_path || opts[:config_file] || lib.config_file(agent)}"
      #argv << " -d #{opts[:pid_file] || lib.pid_file(agent)}"
      argv << " -o #{agent.log_path || opts[:log_file] || lib.log_file(agent)}"
      argv
    end

  end
end
