# frozen_string_literal: true

require "byebug" if %w[test development].include?(ENV["ACTIVE_TASK_ENV"])
require "rake"

require "active_task/active_task"
require "active_task/configuration"
require "active_task/database"
require "active_task/exceptions"
require "active_task/middleware"
require "active_task/railtie" if defined?(Rails)
require "active_task/task"
require "active_task/version"
