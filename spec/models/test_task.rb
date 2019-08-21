require "active_task/task"

class TestTask < ActiveTask::Task
  execute(:method, :my_method)
end