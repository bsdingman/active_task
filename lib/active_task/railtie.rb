require "active_task"

module ActiveTask
  class Railtie < Rails::Railtie
    rake_tasks do
      #load "active_task/rake_tasks/tests.rake"
      load "active_task/rake_tasks/active_task.rake"
    end
  end
end