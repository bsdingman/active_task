require "active_task/task/internal/running_task"
require "active_task/task/internal/rake_task"
require "active_task/task/base"

module ActiveTask
  module Task
    def self.run
      require "./tasks/20190820192934_some_code.rb"
      task = SomeCode.instantiate
      puts "Is Valid: #{task.valid?} | Errors: #{task.errors}"
      task.execute_tasks
      puts "Done"
    end
  end
end