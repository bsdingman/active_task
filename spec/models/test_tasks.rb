# frozen_string_literal: true

class MethodTask < ActiveTask::Task::Base
  execute :method, :my_method

  def my_method
    "Hello World"
  end
end

class SystemCommandTask < ActiveTask::Task::Base
  execute :system, "ls"
  execute :system, "which ruby", "which gem"
end

class RakeTask < ActiveTask::Task::Base
  execute :rake, "active_task_testing:valid"
  execute :rake, "active_task_testing:valid", "active_task_testing:another_valid"
  execute :rake, "active_task_testing:valid_args": %w[1 2]
end

class MissingMethodTask < ActiveTask::Task::Base
  execute :method, :my_method
end

class MethodRaiseExceptionTask < ActiveTask::Task::Base
  execute :method, :my_exception_method

  def my_exception_method
    # foo is undefined
    foo
  end
end

class UndefinedRakeTask < ActiveTask::Task::Base
  execute :rake, "test_rake"
end

class SystemRaiseExceptionTask < ActiveTask::Task::Base
  execute :system, "t"
end

class RakeRaiseExceptionTask < ActiveTask::Task::Base
  execute :rake, "active_task_testing:raise_exception"
end
