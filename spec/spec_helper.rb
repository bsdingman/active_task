require "bundler/setup"
require "active_task"

# Load rake tasks
load "active_task/rake_tasks/tests.rake"
Rake::Task.define_task(:environment)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  #config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# Clean up the tasks folder
Dir["#{File.expand_path("./tasks")}/*.rb"].each{ |f| File.delete(f) }

def generate_task(name, contents)
  task = File.new("#{File.expand_path("./tasks")}/12345678901234_#{name}.rb", File::CREAT|File::RDWR)
  task.write(contents)
  task.close
end