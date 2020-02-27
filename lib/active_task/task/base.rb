# frozen_string_literal: true

module ActiveTask
  class Task
    class Base
      ###################################
      # Public Class Methods
      ###################################
      class << self
        attr_accessor :tasks, :version
      end

      def self.execute(task_type, *task_attributes)
        @tasks ||= []
        @tasks << ActiveTask::Task::Internal::RunningTask.new(task_type, task_attributes)
      end

      ###################################
      # Public Instance Methods
      ###################################
      attr_accessor :tasks, :errors, :version
      def initialize(version)
        @tasks = self.class.tasks
        @klass_name = self.class.name
        @errors = []
        @version = version
      end

      def valid?
        valid = true

        @tasks.each do |task|
          begin
            check_validity(task)
          rescue ActiveTask::Exceptions::InvalidTask, ActiveTask::Exceptions::InvalidRakeTask, ActiveTask::Exceptions::InvalidMethodTask => e
            @errors << e.message
            valid = false
          end
        end

        valid
      end

      def execute_tasks!
        @tasks.each do |task|
          case task.task_type
          when :rake
            execute_rakes(task)
          when :system
            execute_system_commands(task)
          when :method
            execute_methods(task)
          end
        end
      end

      def mark_as_completed!
        ActiveTask.resource.create!(version: @version)
      end

      def errors_as_string
        error_string = "\n#{@klass_name} failed validation with errors:\n"

        @errors.each do |error|
          error_string += "\t#{error}"
        end

        error_string
      end

      protected

      def check_validity(task)
        case task.task_type
        when :rake
          verify_rakes(task)
        when :method
          verify_methods(task)
        when :system
          # Haven't found a good way to check if system commands exist
          nil
        else
          raise ActiveTask::Exceptions::InvalidTask, "Type \"#{task.task_type}\" is not a valid task type"
        end
      end

      def verify_rakes(task)
        task.task_attributes.each do |rake_task|
          if rake_task.is_a?(Hash)
            rake_task.each do |rake, _args|
              raise ActiveTask::Exceptions::InvalidRakeTask, "Could not find rake task \"#{rake}\"" if !Rake::Task.task_defined?(rake)
            end
          else
            raise ActiveTask::Exceptions::InvalidRakeTask, "Could not find rake task \"#{rake_task}\"" if !Rake::Task.task_defined?(rake_task)
          end
        end
      end

      def verify_methods(task)
        task.task_attributes.each do |method_name|
          raise ActiveTask::Exceptions::InvalidMethodTask, "Method \"#{method_name}\" has not been defined" if !self.class.method_defined?(method_name)
        end
      end

      def execute_rakes(task)
        task.task_attributes.each do |rake_task|
          begin
            if rake_task.is_a?(Hash)
              rake_task.each do |rake, args|
                ActiveTask::Task::Internal::RakeTask.invoke(rake, arguments: args)
              end
            else
              ActiveTask::Task::Internal::RakeTask.invoke(rake_task)
            end
          rescue Exception => e # rubocop:disable Lint/RescueException
            raise ActiveTask::Exceptions::FailedTask.new(@klass_name, e.message)
          end
        end
      end

      def execute_system_commands(task)
        task.task_attributes.each do |system_command|
          `#{system_command}`
        end
      rescue Exception => e # rubocop:disable Lint/RescueException
        raise ActiveTask::Exceptions::FailedTask.new(@klass_name, e.message)
      end

      def execute_methods(task)
        task.task_attributes.each do |method_name|
          send(method_name)
        end
      rescue Exception => e # rubocop:disable Lint/RescueException
        raise ActiveTask::Exceptions::FailedTask.new(@klass_name, e.message)
      end
    end
  end
end
