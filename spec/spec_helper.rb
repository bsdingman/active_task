# frozen_string_literal: true

require "bundler/setup"
require "active_task"
require "securerandom"

# Load rake tasks
load "active_task/rake_tasks/tests.rake"
load "active_task/rake_tasks/active_task.rake"
Rake::Task.define_task(:environment)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

ActiveTask.configure do |c|
  c.table_name = :testing_tables
  c.database_yml = File.join(File.expand_path("./spec/config"), "database.yml")
end

def clear_task_folder
  # Clean up the tasks folder
  Dir["#{File.expand_path("./tasks")}/*.rb"].each { |f| File.delete(f) }
end

def generate_version
  nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
  (0..13).map { nums[rand(nums.length)] }.join
end

def generate_task(name, contents)
  task_name = "#{generate_version}_#{name}.rb"
  task = File.new("#{File.expand_path("./tasks")}/#{task_name}", File::CREAT | File::RDWR)
  task.write(contents)
  task.close

  task_name
end

def parse_version_from_task_name(task_name)
  task_name.match(/(\d{14})_(.*)\.rb$/i)[1]
end

clear_task_folder
