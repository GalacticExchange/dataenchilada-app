# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :plugin do
    gem_name "fluent-plugin-dummy"
    version "1.2.3"
  end
end
