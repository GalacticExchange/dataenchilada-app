Rails.application.routes.draw do

  # debug
  get '/debug/:action', to: 'debug#action'


  #
  root "welcome#home"

  resources :agents, only: [:index, :new, :show] do
    member do
      get 'manage'
      post 'command'
      get 'raw_log'
      get 'edit_config'
      post 'update_config'
    end
  end

  resource :daemon, controller: :fluentd do
    get "log"
    get "raw_log"
    get "errors"

    scope module: :fluentd do
      resource :agent, only: [] do
        put "start"
        put "stop"
        put "restart"
        get "log_tail"
      end

      resource :setting, only: [:show, :edit, :update] do
        get "source_and_output"
        get "source"

        resource :in_tail, only: [:show], module: :settings, controller: :in_tail do
          post "after_file_choose"
          post "after_format"
          post "confirm"
          post "finish"
          post "edit"
          post "update_config"
        end

        resource :in_twitter, only: [:show], module: :settings, controller: :in_twitter do
          post "finish"
          post "edit"
          post "update_config"
        end

        resource :in_kafka, only: [:show], module: :settings, controller: :in_kafka do
          post "finish"
          post "edit"
          post "update_config"
        end

        resource :in_sql, only: [:show], module: :settings, controller: :in_sql do
          post "finish"
          post "edit"
          post "update_config"
        end

        resource :in_syslog, only: [:show], module: :settings, controller: :in_syslog do
          post "finish"
        end

        resource :in_monitor_agent, only: [:show], module: :settings, controller: :in_monitor_agent do
          post "finish"
        end

        resource :in_http, only: [:show], module: :settings, controller: :in_http do
          post "finish"
          post "edit"
          post "update_config"
        end

        resource :in_netflow, only: [:show], module: :settings, controller: :in_netflow do
          post "finish"
          post "edit"
          post "update_config"
        end

        resource :in_mixpanel, only: [:show], module: :settings, controller: :in_mixpanel do
          post "finish"
          post "edit"
          post "update_config"
        end

        resource :in_forward, only: [:show], module: :settings, controller: :in_forward do
          post "finish"
          post "edit"
          post "update_config"
        end

        resource :out_stdout, only: [:show], module: :settings, controller: :out_stdout do
          post "finish"
        end

        resource :out_mongo, only: [:show], module: :settings, controller: :out_mongo do
          post "finish"
        end

        resource :out_td, only: [:show], module: :settings, controller: :out_td do
          post "finish"
        end

        resource :out_s3, only: [:show], module: :settings, controller: :out_s3 do
          post "finish"
        end

        resource :out_forward, only: [:show], module: :settings, controller: :out_forward do
          post "finish"
        end

        resource :out_elasticsearch, only: [:show], module: :settings, controller: :out_elasticsearch do
          post "finish"
        end

        resources :histories, only: [:index, :show], module: :settings, controller: :histories do
          post "reuse", action: 'reuse', on: :member, as: 'reuse'
          post "configtest" , action: "configtest", on: :member, as: "configtest"
        end

        resources :notes, only: [:update], module: :settings, controller: :notes

        resource :running_backup, only: [:show], module: :settings, controller: :running_backup do
          post "reuse", action: 'reuse', on: :member, as: 'reuse'
          post "configtest" , action: "configtest", on: :member, as: "configtest"
        end
      end
    end
  end

  resource :sessions

  resources :plugins do
    collection do
      get :installed
      get :recommended
      get :updated
      patch :install
      patch :uninstall
      patch :upgrade
      patch :bulk_upgrade
    end
  end

  resource :user, only: [:show, :edit, :update]

  get "misc" => "misc#show"
  get "misc/information"
  post "misc/update_fluentd_ui"
  get "misc/upgrading_status"
  get "misc/download_info"

  namespace :polling do
    get "alerts"
  end

  namespace :tutorials do
    get "/" => :index
    get "chapter1"
    get "chapter2"
    get "chapter3"
    get "chapter4"
    get "chapter5"
    get "log_tail"
    post "request_fluentd"
  end

  namespace :api do
    get "tree"
    get "file_preview"
    post "regexp_preview"
    post "grok_to_regexp"

    resources :settings, only: [:index, :show, :update, :destroy], defaults: { format: "json" }
  end
end
