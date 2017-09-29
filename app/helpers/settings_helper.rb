module SettingsHelper
  def field(form, key, opts = {})
    html = '<div class="form-group">'

    field_resolver(form.object.try(:column_type, key), html, form, key, opts)
    html << "<small class='form-text text-muted'>#{form.object.fields_descriptions[key]}</small>" if form.object.try(:fields_descriptions).present?
    html << "</div>"
    html.html_safe
  end

  private
  def field_resolver(type, html, form, key, opts)
    case type
    when :hidden
      html << form.hidden_field(key)
    when :boolean, :flag
      boolean_field(html, form, key, opts)
    when :choice
      choice_field(html, form, key, opts)
    when :nested
      nested_field(html, form, key, opts)
    else
      other_field(html, form, key, opts)
    end
  end

  def nested_field(html, form, key, opts = {})
    klass    = child_data(form, key)[:class]
    options  = child_data(form, key)[:options]
    children = form.object.send(key) || {"0" => {}}

    children.each_pair do |index, child|
      html << open_nested_div(options[:multiple])
      html << append_and_remove_links if options[:multiple]
      html << h(form.label(key))
      html << nested_fields(form, key, index, klass, child)
      html << "</div>"
    end
  end

  def open_nested_div(multiple)
    %Q!<div class="js-nested-column #{ multiple ? "js-multiple" : "" } well well-sm">!
  end

  def nested_fields(form, key, index, klass, child)
    nested_html = ""
    form.fields_for("#{key}[#{index}]", klass.new(child)) do |ff|
      klass::KEYS.each do |k|
        nested_html << field(ff, k)
      end
    end

    nested_html
  end

  def append_and_remove_links
    %Q!<a class="btn btn-xs btn-default js-append">#{icon('fa-plus')}</a> ! +
    %Q!<a class="btn btn-xs btn-default js-remove" style="display:none">#{icon('fa-minus')}</a> !
  end

  def child_data(form, key)
    form.object.class.children[key]
  end

  def choice_field(html, form, key, opts = {})
    html << h(form.label(key))
    html << " " # NOTE: Adding space for padding
    html << form.select(key, form.object.values_of(key), opts)
  end

  def boolean_field(html, form, key, opts = {})
    html << form.check_box(key, {}, "true", "false")
    html << " " # NOTE: Adding space for padding
    html << h(form.label(key))
  end

  def other_field(html, form, key, opts = {})
    html << h(form.label(key))
    html << form.text_field(key, class: "form-control")
  end
  #
  # def outputs_types_with_icons
  #   {
  #       kafka: {
  #           icon: 'fa-file-text-o'
  #       },
  #       elasticsearch: {
  #           icon: 'fa-file-text-o'
  #       },
  #       webhdfs: {
  #           icon: 'fa-file-text-o'
  #       },
  #       kassandra: {
  #           icon: 'fa-file-text-o'
  #       }
  #   }
  # end

  def settings_types_with_icons
    {
        tail: {
            icon: 'fa-file-text-o',
            edit_link: '',
            preview_fields: [
                :path,
                :format,
                :tag
            ]
        },
        twitter: {
            icon: 'fa-twitter',
            edit_link: edit_daemon_setting_in_twitter_path,
            preview_fields: [
                :keyword,
                :tag,
                :timeline
            ]
        },
        sql: {
            icon: 'fa-database',
            edit_link: edit_daemon_setting_in_sql_path,
            preview_fields: [
                :host,
                :database,
                :adapter
            ]
        },
        forward: {
            icon: 'fa-mail-forward',
            edit_link: edit_daemon_setting_in_forward_path,
            create_link: daemon_setting_in_forward_path,
            preview_fields: [
                :bind,
                :port
            ],
            # default_params: Fluentd::Setting::InForward.default_element
        },
        http: {
            icon: 'fa-globe',
            edit_link: edit_daemon_setting_in_http_path,
            create_link: daemon_setting_in_http_path,
            preview_fields: [
                :bind,
                :port
            ],
            # default_params: Fluentd::Setting::InHttp.default_element
        },
        netflow: {
            icon: 'fa-exchange',
            edit_link: edit_daemon_setting_in_netflow_path,
            create_link: daemon_setting_in_netflow_path,
            preview_fields: [
                :bind,
                :port
            ],
            # default_params: Fluentd::Setting::InHttp.default_element
        },
        kafka: {
            icon: 'fa-cloud',
            edit_link: edit_daemon_setting_in_kafka_path,
            create_link: daemon_setting_in_kafka_path,
            preview_fields: [
                :bind,
                :port
            ],
            # default_params: Fluentd::Setting::InHttp.default_element
        },
    }
  end

  def listeners_types_with_icons
    {
        # forward: {
        #     icon: 'fa-mail-forward',
        #     edit_link: edit_daemon_setting_in_forward_path,
        #     create_link: daemon_setting_in_forward_path,
        #     preview_fields: [
        #         :bind,
        #         :port
        #     ],
        #     default_params: Fluentd::Setting::InForward.default_element
        # },
        # http: {
        #     icon: 'fa-globe',
        #     edit_link: edit_daemon_setting_in_http_path,
        #     create_link: daemon_setting_in_http_path,
        #     preview_fields: [
        #         :bind,
        #         :port
        #     ],
        #     default_params: Fluentd::Setting::InHttp.default_element
        # },
        # http_mixpanel: {
        #     icon: 'fa-bar-chart',
        #     edit_link: edit_daemon_setting_in_mixpanel_path,
        #     create_link: daemon_setting_in_mixpanel_path,
        #     preview_fields: [
        #         :bind,
        #         :port
        #     ],
        #     default_params: Fluentd::Setting::InMixpanel.default_element
        # }
    }
  end

  def required?(obj, attribute)
    target = (obj.class == Class) ? obj : obj.class
    target.validators_on(attribute)
        .map(&:class)
        .include?(ActiveModel::Validations::PresenceValidator)
  end
end
