class ValidMethodTask < ActiveTask::Task::Base
  execute :method, :my_method

  def my_method
    "Hello World"
  end
end

class ValidCommandTask < ActiveTask::Task::Base
  execute :command, "ls"
end

class ValidRakeTask < ActiveTask::Task::Base
  execute :rake, "active_task_testing:valid"
end

class FailureMissingMethodTask < ActiveTask::Task::Base
  execute :method, :my_method
end

class FailureRaiseExceptionMethodTask < ActiveTask::Task::Base
  execute :method, :my_exception_method

  def my_exception_method
    foo
  end
end

class FailureRakeTask < ActiveTask::Task::Base
  execute(:rake, "test_rake")
end