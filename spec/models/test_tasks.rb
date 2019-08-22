require "active_task/task"

class ValidMethodTask < ActiveTask::Task::Base
  execute(:method, :my_method)

  def my_method
    puts "Hello World"
  end
end

class FailureMethodTask < ActiveTask::Task::Base
  execute(:method, :my_method)
end

class FailureCommandTask < ActiveTask::Task::Base
  execute(:command, "bundle install")
end

class FailureRakeTask < ActiveTask::Task::Base
  execute(:rake, "test_rake")
end