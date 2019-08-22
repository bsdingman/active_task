require "active_task/task"

class FailureMethodTask < ActiveTask::Task::Base
  execute(:method, :my_method)
end

class FailureCommandtask < ActiveTask::Task::Base
  execute(:command, "bundle install")
end