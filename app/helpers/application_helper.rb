# coding: utf-8

module ApplicationHelper
  def has_td_agent_system?
    File.exist?("/etc/init.d/td-agent") || File.exist?("/opt/td-agent/embedded/bin/fluentd")
  end

  def fluentd_ui_logo
    image_tag(ENV["FLUENTD_UI_LOGO"] || "/enchilada_logo.png")
  end

  def fluentd_status_icon
    return unless Fluentd.instance
    Fluentd.instance.agent.running? ? icon('fa-circle running') : icon('fa-circle stopped')
  end

  def fluentd_status_message
    return unless Fluentd.instance
    Fluentd.instance.agent.running? ? I18n.t('messages.fluentd_status_running') : I18n.t('messages.fluentd_status_stopped')
  end

  def language_name(locale)
    # NOTE: these are fixed terms, not i18n-ed
    {
      en: "English",
      ja: "日本語",
    }[locale] || locale
  end

  def language_menu
    html = ""
    I18n.available_locales.each do |locale|
      text = (locale == current_locale ? icon("fa-check") : "")
      text << language_name(locale)
      html << %Q|<li>#{link_to text , "?lang=#{locale}"}</li>|
    end
    raw html
  end

  def link_to_other(text, path)
    if current_page?(path)
      # NOTE: sb-admin set style for element name instead of class name, such as ".nav a". So use "a" element even if it isn't a link.
      content_tag(:a, text, class: "current")
    else
      link_to text, path
    end
  end

  def icon(classes, inner=nil)
    %Q!<i class="fa #{classes}">#{inner}</i> !.html_safe
  end

  def page_title(title, &block)
    content_for(:page_title) do
      title
    end
    page_head(title, &block) unless content_for?(:page_head)
  end

  def page_head(head, &block)
    content_for(:page_head) do
      head.html_safe + block.try(:call).to_s
    end
  end


  ### forms

  def vertical_simple_form_for(resource, options = {}, &block)
    options[:html] ||= {}

    # class
    options[:html][:class] ||= []
    if options[:html][:class].is_a? Array
      options[:html][:class] << 'form-vertical'
    else
      options[:html][:class] << ' form-vertical'
    end
    options[:html][:role] = 'form'


    options[:wrapper] = :vertical_form
    options[:wrapper_mappings] = {
        check_boxes: :vertical_radio_and_checkboxes,
        radio_buttons: :vertical_radio_and_checkboxes,
        file: :vertical_file_input,
        boolean: :vertical_boolean
    }

    simple_form_for(resource, options, &block)
  end

end
