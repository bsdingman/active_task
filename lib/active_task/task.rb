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

    private
    def self.tasks
      # Get all the previous versions that we've ran. 
      previous_versions = ActiveTask.table_name.constantize.all
      
      # Ignoring previous versions, build an array of tasks to run
      Dir["#{File.expand_path("./tasks")}/*.rb"].map do |task| 
        task = ActiveTask::Task::Internal::FileTask.new(task)
        next if previous_versions.include?(task.version)
        task
      end
    end

    def self.execute!
      tasks.each do |task|
        # Require the task via it's file path
        require task.file_path

        klass = task.name.camelize.constantize
        running_task = klass.instantiate

        if !running_task.valid?
          raise Exception.new(running_task.errors_as_string)
        end

        running_task.execute_tasks
      end
    end
  end
end