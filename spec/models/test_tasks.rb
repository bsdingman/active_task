class ValidMethodTask < ActiveTask::Task::Base
  execute(:method, :my_method)

  def my_method
    puts "Hello World"
  end
end

class FailureMissingMethodTask < ActiveTask::Task::Base
  execute(:method, :my_method)
end

class FailureRaiseExceptionMethodTask < ActiveTask::Task::Base
  execute(:method, :my_exception_method)

  def my_exception_method
    foo
  end
end

class FailureRakeTask < ActiveTask::Task::Base
  execute(:rake, "test_rake")
end