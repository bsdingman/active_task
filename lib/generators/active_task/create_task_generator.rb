require 'rails/generators'
require 'active_support/core_ext/string'

module ActiveTask
  module Generators
    class CreateTaskGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)
      argument :name, type: :string
    
      desc "This generator creates a ActiveTask task"
      def create
        @formatted_name = name.underscore
        # YYYYMMDDHHMMSS_NAME.rb
        template "task.erb", "tasks/#{Time.now.strftime("%Y%m%d%H%M%S")}_#{@formatted_name}.rb"
      end
    end
  end
end