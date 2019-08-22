require "rake"

module ActiveTask
  module Task
    class Base
      ###################################
      # Public Methods
      ###################################
      class << self
        attr_accessor :klass, :tasks, :errors
      end
      
      def self.define_variables
        @klass ||= self.name
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
          rescue InvalidTask, InvalidRakeTask, InvalidCommandTask, InvalidMethodTask => ex
            @errors << ex.message
            valid = false
          end
        end

        valid
      end

      protected
      def self.check_validity(task)
        case task.task_type
        when :rake, :rakes
          verify_rakes(task)
        when :method, :methods
          verify_methods(task)
        else
          raise InvalidTask.new("Type \"#{task.task_type}\" is not a valid task type")
        end
      end

      def self.verify_rakes(task)
        task.task_attributes.each do |rake_task|
          if !Rake::Task.task_defined?(rake_task)
            raise InvalidRakeTask.new("Task \"#{@klass}\" could not find rake task \"#{rake_task}\"")
          end
        end
      end

      def self.verify_methods(task)
        task.task_attributes.each do |method_name|
          if !method_defined?(method_name)
            raise InvalidMethodTask.new("Task \"#{@klass}\" method task method \"#{method_name}\" has not been defined")
          end
        end
      end

      def self.execute_rakes(rake_tasks)

      end

      def self.execute_commands(commands)
        
      end

      def self.execute_methods(method_names)
        method_names.each do |method_name|
          if defined?(method_name)
            self.send(method_name)
          else
            raise FailedTask.new(self.class.name, "Method #{method_name} has not been defined")
          end
        end
      end
    end
  end
end