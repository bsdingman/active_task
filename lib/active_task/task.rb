module ActiveTask
  class Task
    def self.define_variables
      @name ||= self.name
      @tasks ||= []
      @errors ||= []
      @task_struct ||= Struct.new(:type, :attributes)
    end

    def self.execute(task_type, *attributes)
      define_variables

      @tasks << @task_struct.new(
        type: task_type,
        attributes: attributes
      )
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
      case task.type
      when :rake, :rakes
        verify_rake(task)
      when :command, :commands
        verify_command(task)
      when :method, :methods
        verify_method(task)
      else
        raise InvalidTask.new("Type \"#{task.type}\" is not a valid task type")
      end
    end

    def self.verify_rakes(task)
      raise InvalidRakeTask.new("TODO")
    end

    def self.execute_commands(task)
      raise InvalidCommandTask.new("TODO")
    end

    def self.verify_methods(task)
      if task.attributes == []
        raise InvalidMethodTask.new("Task \"#{@name}\" method task was not given any methods to execute")
      else
        task.attributes.each do |method_name|
          if !defined?(method_name)
            raise InvalidMethodTask.new("Task \"#{@name}\" method task method #{method_name} has not been defined")
          end
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