require "active_task"
require "rails"

module ActiveTask
  class Railtie < Rails::Railtie
    railtie_name :active_task

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/rake_tasks/**/*.rake").each { |f| load f }
    end
  end
end