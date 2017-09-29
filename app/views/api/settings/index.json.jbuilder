json.array! @config_elements do |elm|
  json.partial! "api/settings/element", element: elm
end
