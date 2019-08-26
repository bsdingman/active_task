require 'rails/generators'

module ActiveTask
  module Generators
    class SetupGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
    
      desc "This generator creates a ActiveTask initializer"
      def create
        template "initializer.erb", "config/initializers/active_task.rb"
      end
    end
  end
end