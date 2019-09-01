require "active_task/task/internal/running_task"
require "active_task/task/internal/rake_task"
require "active_task/task/internal/file_task"
require "active_task/task/base"

module ActiveTask
  module Task
    def self.run
      # Connect to the DB if we aren't already
      if !ActiveTask::DatabaseConnector.connected?
        ActiveTask::DatabaseConnector.connect
      end

      execute!
    end

    def self.mark_completed(file_name)
      # Remove the .rb from the end
      if file_name.end_with?(".rb")
        file_name = file_name[0..-4]
      end
      
      # Create the task and mark it completed
      task = ActiveTask::Task::Internal::FileTask.new("#{File.expand_path("./tasks")}/#{file_name}.rb")
      require task.file_path
      running_task = task.name.camelize.constantize.instantiate(task.version)
      running_task.mark_as_completed!
    end

    private
    def self.task_already_completed?(task)
      ActiveTask.resource.where(version: task.version).any?
    end

    def self.tasks      
      # Ignoring previous versions, build an array of tasks to run. Compact will remove any nils
      Dir["#{File.expand_path("./tasks")}/*.rb"].map do |task| 
        task = ActiveTask::Task::Internal::FileTask.new(task)
        next if task_already_completed?(task)
        task
      end.compact
    end

    def self.execute!
      tasks.each do |task|
        puts "Running task: #{task.name}:#{task.version}"
        # Require the task via it's file path
        require task.file_path

        klass = task.name.camelize.constantize
        running_task = klass.instantiate(task.version)

        if !running_task.valid?
          raise Exception.new(running_task.errors_as_string)
        end

        # Execute the pending tasks. This will raise if failed
        running_task.execute_tasks!

        # Marking the task as completed will put it in the database
        running_task.mark_as_completed!
      end
    end
  end
end