require "rake"

module ActiveTask
  module Task
    class Base
      ###################################
      # Public Methods
      ###################################
      class << self
        attr_accessor :klass_name, :tasks, :errors
      end
      
      def self.define_variables
        @klass_name ||= self.name
        @tasks ||= []
        @errors ||= []
      end

      def self.execute(task_type, *task_attributes)
        define_variables
        @tasks << Internal::RunningTask.new(task_type, task_attributes)
      end

      def self.valid?
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

      def self.execute_tasks
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
      def self.check_validity(task)
        case task.task_type
        when :rake
          verify_rakes(task)
        when :method
          verify_methods(task)
        else
          raise ActiveTask::Exceptions::InvalidTask.new("Type \"#{task.task_type}\" is not a valid task type")
        end
      end

      def self.verify_rakes(task)
        task.task_attributes.each do |rake_task|
          if !Rake::Task.task_defined?(rake_task)
            raise ActiveTask::Exceptions::InvalidRakeTask.new("Task \"#{@klass_name}\" could not find rake task \"#{rake_task}\"")
          end
        end
      end

      def self.verify_methods(task)
        task.task_attributes.each do |method_name|
          if !method_defined?(method_name)
            raise ActiveTask::Exceptions::InvalidMethodTask.new("Task \"#{@klass_name}\" method task method \"#{method_name}\" has not been defined")
          end
        end
      end

      def self.execute_rakes(task)

      end

      def self.execute_commands(task)
        
      end

      def self.execute_methods(task)
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