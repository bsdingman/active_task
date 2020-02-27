# frozen_string_literal: true

require 'rails/generators'
require 'active_support/core_ext/string'

module ActiveTask
  module Generators
    class TaskGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      argument :name, type: :string

      desc "This generator creates a ActiveTask task"
      def task
        @formatted_name = name.underscore
        @time = Time.now.strftime("%Y%m%d%H%M%S")

        template "task.erb", "tasks/#{@time}_#{@formatted_name}.rb"
      end
    end
  end
end
