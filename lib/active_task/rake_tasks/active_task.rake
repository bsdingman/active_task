# frozen_string_literal: true

namespace :active_task do
  desc "Run any pending tasks"
  task run: :environment do
    ActiveTask::Task.run
  end

  desc "Mark a task as completed"
  task mark_completed: :environment do
    print "What is the file name of the task you want to mark completed? "
    task_name = STDIN.gets.chomp
    ActiveTask::Task.mark_completed(task_name)
  end
end
