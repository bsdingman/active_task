require "active_task"

module ActiveTask
  class Railtie < Rails::Railtie
    rake_tasks do
      #load "active_task/rake_tasks/tests.rake"
    end
  end
end