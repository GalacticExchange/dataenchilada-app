listener = false
preview = settings_types_with_icons[element['type'].to_s.to_sym]
if preview.blank?
  preview = listeners_types_with_icons[element['type'].to_s.to_sym]
  listener = true if preview.present?
end

if preview.present?
  edit_link = preview[:edit_link]
  preview_fields = preview[:preview_fields]
end

element_exists = element_id(element).present? rescue false

json.id(element_exists ? element_id(element) : rand(99999))
json.name listener ? 'listener' : element.name
json.type I18n.t("fluentd.common.setup_in_#{element['type']}")
json.arg element.arg
json.settings element
json.content element.to_s
json.existing_element element_exists

if preview.present? && preview_fields.present?
  json.edit_link edit_link
  json.preview (preview_fields.map{|field| "#{field}: #{element[field.to_s]}"} + (!listener ? ["topic_prefix: #{(element['tag'] || element['tag_prefix']).to_s.gsub('.', '_')}"] : [])).join("\n")
  json.icon icon("#{preview[:icon]} fa-lg").html_safe
end
unless element_exists
  json.create_link preview[:create_link]
end