module ActiveTask
  module Task
    module Internal
      class RunningTask
        attr_accessor :task_type, :task_attributes
        
        def initialize(task_type, task_attributes)
          @task_type = task_type
          @task_attributes = task_attributes
        end
      end
    end
  end
end