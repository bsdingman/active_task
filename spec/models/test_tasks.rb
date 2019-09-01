class ValidMethodTask < ActiveTask::Task::Base
  execute :method, :my_method

  def my_method
    "Hello World"
  end
end

class ValidSystemCommandTask < ActiveTask::Task::Base
  execute :system, "ls"
  execute :system, "which ruby", "which gem"
end

class SystemRaiseExceptionTask < ActiveTask::Task::Base
  execute :system, "t"
end

class ValidRakeTask < ActiveTask::Task::Base
  execute :rake, "active_task_testing:valid"
  execute :rake, "active_task_testing:valid", "active_task_testing:another_valid"
  execute :rake, "active_task_testing:valid_args": ["1", "2"]
end

class FailureMissingMethodTask < ActiveTask::Task::Base
  execute :method, :my_method
end

class MethodRaiseExceptionTask < ActiveTask::Task::Base
  execute :method, :my_exception_method

  def my_exception_method
    foo
  end
end

class FailureRakeTask < ActiveTask::Task::Base
  execute :rake, "test_rake"
end

class RakeRaiseExceptionTask < ActiveTask::Task::Base
  execute :rake, "active_task_testing:raise_exception"
end