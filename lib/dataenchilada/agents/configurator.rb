module Dataenchilada::Agents
  class Configurator

    ###
    def self.logger
      Rails.logger
    end

    ### main method

    def self.generate_config(agent)

      res = {}

      tag = agent.tag

      res['tag'] = tag
      #tag = "mytag"

      # sources
      source = agent.source
      s_source = generate_config_source(source)
      res['source'] = s_source

      # outputs
      res['outputs'] = []
      agent.outputs.each do |output|
        res['outputs'] << generate_config_output(output, tag)
      end


      # save to file
      write_config_file(agent, res)

      true
    end

    def self.write_config_file(agent, data)
      f_out = config_filename(agent)

      d = File.dirname(f_out)
      FileUtils.mkdir_p(d) unless Dir.exists?(d)

      #
      f_tpl = filename_template_agent(agent.agent_type.name)

      tpl_vars = {
          tag: data['tag'],
          source: data['source'],
          outputs: data['outputs'],
      }

      content = process_erb_file(f_tpl, tpl_vars)


      File.open(f_out,'w') do |f|
        f.write(content)
      end

      true
    end

    def self.generate_config_source(source, extra_args={})
      agent = source.engine

      f_tpl = filename_template_input(agent.agent_type.name, source.source_type_name)

      #
      props_system = get_system_props
      props = build_source_props(source)

      tpl_vars = {
          tag: agent.tag,
          agent: agent,
          source: source,
          props: props,
          #servers: props_servers,
          system: props_system
      }

      process_erb_file(f_tpl, tpl_vars)
    end


    def self.generate_config_output(output, tag, extra_args={})
      agent = output.engine

      f_tpl = filename_template_output(agent.agent_type.name, output.output_type_name)

      #
      props_system = get_system_props
      props_servers = build_servers_props(props_system)
      props = build_output_props(output, tag)
      #output.details.attributes.to_hash


      tpl_vars = {
          agent: agent,
          output: output,
          props: props,
          servers: props_servers,
          system: props_system
      }

      process_erb_file(f_tpl, tpl_vars)
    end


    ### source props

    def self.build_source_props(source)

      mtd = :"build_source_props_#{source.source_type_name}"
      if respond_to?(mtd)
        return send(mtd, source)
      end

      nil
    end

    def self.build_source_props_tail(source)
      {
          "path"=>source.details.path,
          #"pos_file"=>source.details.pos_file,

      }
    end



    ### output props

    def self.build_output_props(output, tag)

      mtd = :"build_output_props_#{output.output_type_name}"
      if respond_to?(mtd)
        return send(mtd, output, tag)
      end

      nil
    end

    def self.build_output_props_elasticsearch(output, tag)
      {
          "index_name"=>tag,
          "type_name"=>tag,

      }
    end


    def self.build_output_props_cassandra(output, tag)
      {
          "column_family"=>tag,

      }
    end

    def self.build_output_props_kafka(output, tag)
      {
          "topic"=>tag,

      }
    end

    ### system props

    def self.get_system_props
      f = "/etc/data_enchilada/data_enchilada.properties"


      if !File.exists?(f)
        logger.error "File not found: #{f}"
        if Rails.env.development?
          f = File.join(Rails.root, "data/temp/data_enchilada.properties")
        end
      end

      properties = JavaProperties.load(f)
      properties
    end


    def self.build_servers_props(props_system)

      {
          "elasticsearch"=>{
              "host"=>props_system[:elasticsearch_host],
              "port"=>props_system[:elasticsearch_port] || 9200,
          },
          'cassandra' =>{
              "host"=>props_system[:cassandra_host],
              "port"=>props_system[:cassandra_port] || 9042,
              "username"=>props_system[:cassandra_username],
              "password"=>props_system[:cassandra_password],
              "keyspace"=>props_system[:cassandra_keyspace],
          },
          "kafka" => {
              "zookeeper_url"=>props_system[:zookeeper]
          }
      }
    end

    ### helpers

    def self.config_filename(agent)
      agent.config_path
    end

    def self.filename_template_agent(agent_type)
      File.join(Rails.root, "data/templates/#{agent_type}", "agent.erb")
    end

    def self.filename_template_input(agent_type, source_type)
      File.join(Rails.root, "data/templates/#{agent_type}/source/", "#{source_type}.erb")
    end


    def self.filename_template_output(agent_type, output_type)
      File.join(Rails.root, "data/templates/#{agent_type}/output/", "#{output_type}.erb")
    end


    def self.process_erb_file(filename, vars)
      # install with supervisor
      require 'erb'
      s_tpl = File.read(filename)

      vars = OpenStruct.new(vars)
      result = ERB.new(s_tpl).result(vars.instance_eval { binding })


      result
    end
  end
end
