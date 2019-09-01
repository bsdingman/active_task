module ActiveTask
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      check_for_tasks
      @app.call(env)
    end

    def check_for_tasks
      if ActiveTask::Task.tasks_pending?
        raise ActiveTask::Exceptions::PendingTask.new("You have pending task(s) that needs completed. Please execute command \"bundle exec rake active_task:run\" to clear this error")
      end
    end
  end
end