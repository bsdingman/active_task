# frozen_string_literal: true

module ActiveTask
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      # Connect to the DB if we aren't already
      ActiveTask::Database.connect if !ActiveTask::Database.connected?

      check_for_tasks
      @app.call(env)
    end

    def check_for_tasks
      raise ActiveTask::Exceptions::PendingTask, "You have pending task(s) that needs completed. Please execute command \"bundle exec rake active_task:run\" to clear this error" if ActiveTask::Task.tasks_pending?
    end
  end
end
