require 'rails/generators'

module ActiveTask
  module Generators
    class SetupGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
    
      desc "This generator creates a ActiveTask initializer"
      def create
        template "initializer.erb", "config/initializers/active_task.rb"

        inject_into_file 'config/environments/development.rb', before: /^end/ do <<-'RUBY'

  # Allow ActiveTask to check for pending tasks
  config.middleware.use(ActiveTask::Middleware)
      RUBY
      end
      end
    end
  end
end