module ActiveTask
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @status, @headers, @response = @app.call(env)
      check_for_tasks
      [@status, @headers, @response]
    end

    def check_for_tasks
      if pending_tasks?
        raise ActiveTask::Exceptions::PendingTask.new("You have a pending task that needs completed. Please execute command \"bundle exec rake at:run\" to clear this error")
      end
    end

    def pending_tasks?
      true
    end
  end
end