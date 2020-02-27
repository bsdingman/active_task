# frozen_string_literal: true

require "active_support/configurable"

module ActiveTask
  class Configuration
    include ActiveSupport::Configurable

    config_accessor(:table_name) { :completed_tasks }
    config_accessor(:database_yml) {}
  end
end
