namespace :active_task do 
  desc ""
  task run: :environment do
    ActiveTask::Task.run
  end
end