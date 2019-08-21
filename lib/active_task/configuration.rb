require "active_support/configurable"

module ActiveTask
  class Configuration 
    include ActiveSupport::Configurable

    config_accessor(:table_name) { :ran_tasks }
  end
end