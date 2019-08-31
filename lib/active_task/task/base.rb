require "rake"

module ActiveTask
  module Task
    class Base
      ###################################
      # Public Class Methods
      ###################################
      class << self
        attr_accessor :tasks, :errors
      end

      def self.define_variables
        @tasks ||= []
        @errors ||= []
      end

      def self.execute(task_type, *task_attributes)
        define_variables
        @tasks << Internal::RunningTask.new(task_type, task_attributes)
      end

      def self.instantiate
        new(@tasks)
      end

      ###################################
      # Public Instance Methods
      ###################################
      attr_accessor :tasks, :errors
      def initialize(tasks)
        @tasks = tasks
        @errors = []
        @klass_name = self.class.name
      end

      def valid?
        valid = true

        @tasks.each do |task|
          begin
            check_validity(task)
          rescue ActiveTask::Exceptions::InvalidTask, ActiveTask::Exceptions::InvalidRakeTask, ActiveTask::Exceptions::InvalidMethodTask => ex
            @errors << ex.message
            valid = false
          end
        end

        valid
      end

      def execute_tasks
        @tasks.each do |task|
          case task.task_type
          when :rake
            execute_rakes(task)
          when :command
            execute_commands(task)
          when :method
            execute_methods(task)
          end
        end
      end

      protected
      def check_validity(task)
        case task.task_type
        when :rake
          verify_rakes(task)
        when :method
          verify_methods(task)
        when :command
          # Haven't found a good way to check if system commands exist
          return
        else
          raise ActiveTask::Exceptions::InvalidTask.new("Type \"#{task.task_type}\" is not a valid task type")
        end
      end

      def verify_rakes(task)
        task.task_attributes.each do |rake_task|
          if rake_task.is_a?(Hash)
            rake_task.each do |rake, args|
              if !Rake::Task.task_defined?(rake)
                raise ActiveTask::Exceptions::InvalidRakeTask.new("Task \"#{@klass_name}\" could not find rake task \"#{rake}\"")
              end
            end
          else
            if !Rake::Task.task_defined?(rake_task)
              raise ActiveTask::Exceptions::InvalidRakeTask.new("Task \"#{@klass_name}\" could not find rake task \"#{rake_task}\"")
            end
          end
        end
      end

      def verify_methods(task)
        task.task_attributes.each do |method_name|
          if !self.class.method_defined?(method_name)
            raise ActiveTask::Exceptions::InvalidMethodTask.new("Task \"#{@klass_name}\" method task method \"#{method_name}\" has not been defined")
          end
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
          rescue Exception => ex
            raise ActiveTask::Exceptions::FailedTask.new(@klass_name, ex.message)
          end
        end
      end

      def execute_commands(task)
        begin
          task.task_attributes.each do |command|
            `#{command}`
          end
        rescue Exception => ex
          raise ActiveTask::Exceptions::FailedTask.new(@klass_name, ex.message)
        end
      end

      def execute_methods(task)
        begin
          task.task_attributes.each do |method_name|
            send(method_name)
          end
        rescue StandardError => ex
          raise ActiveTask::Exceptions::FailedTask.new(@klass_name, ex.message)
        end
      end
    end
  end
end
