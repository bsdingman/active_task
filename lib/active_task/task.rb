# frozen_string_literal: true

require "active_task/task/internal/running_task"
require "active_task/task/internal/rake_task"
require "active_task/task/base"

module ActiveTask
  class Task
    # Ensures an active database connection and executes all pending tasks
    def self.run
      ActiveTask::Database.connect if !ActiveTask::Database.connected?
      execute!
    end

    # Executes all pending tasks
    def self.execute!
      pending_tasks.each do |task|
        puts "Running task #{task.task_name}:#{task.version}"

        # Require the task via it's file path
        require task.file_path

        running_task = task.build!

        raise ActiveTask::Exceptions::InvalidTask, running_task.errors_as_string if !running_task.valid?

        # Execute the pending tasks. This will raise if failed
        running_task.execute_tasks!

        # Marking the task as completed will put it in the database
        running_task.mark_as_completed!
      end
    end

    # Marks a task complete from its filename
    #
    # @param file_name [String] The file name of the task to complete
    def self.mark_completed(file_name)
      # Remove the .rb from the end
      file_name = file_name[0..-4] if file_name.end_with?(".rb")

      # Create the task and mark it completed
      task = self.new("#{File.expand_path("./tasks")}/#{file_name}.rb")

      # Load the class
      require task.file_path

      # Create the task and mark completed
      running_task = task.build!
      running_task.mark_as_completed!
    end

    # Are there any pending tasks?
    #
    # @return [Boolean]
    def self.tasks_pending?
      pending_tasks.any?
    end

    # All pending tasks that need to be completed
    #
    # @return [Array<FileTask>]
    def self.pending_tasks
      # Load all of the tasks
      all_tasks = Dir["#{File.expand_path("./tasks")}/*.rb"].map { |task| self.new(task) }

      # Load all completed task versions
      completed_task_versions = ActiveTask.resource.all.pluck(:version)

      # Remove the completed tasks and return the ones that need completed
      all_tasks.reject { |task| completed_task_versions.include?(task.version) }
    end

    attr_reader :version, :file_path, :task_name

    # Creates a task from the task's filepath
    #
    # @param file_path [String] The full path to the task
    def initialize(file_path)
      # Converts 1234567890_my_task.rb -> [version, task_name]
      match = file_path.match(/(\d{14})_(.*)\.rb$/i)

      @file_path = file_path
      @version = match[1]
      @task_name = match[2]
    end

    # Creates an instance of the actual task written by the user
    def build!
      klass = self.task_name.camelize.constantize
      klass.new(self.version)
    end
  end
end
