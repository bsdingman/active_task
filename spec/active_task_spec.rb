require "active_task"

describe ActiveTask do
  it "should be configured" do 
    ActiveTask.configure do |c|
      c.table_name = :testing_tables
      c.database_yml = File.join(File.expand_path("./spec/config"), "database.yml")
    end

    expect(ActiveTask.config.table_name).to be(:testing_tables)
  end

  it "should throw an PendingTask" do
    active_task = ActiveTask::Middleware.new(nil)
    expect{ active_task.check_for_tasks }.to raise_error("You have a pending task that needs completed. Please execute command \"bundle exec rake at:run\" to clear this error")
  end

  it "should be connected to ActiveRecord" do
    ActiveTask::DatabaseConnector.connect
    expect(ActiveRecord::Base.connected?).to be(true)
  end

  it "should have the task table created" do
    expect(ActiveRecord::Base.connection.table_exists?( ActiveTask.config.table_name)).to be(true)
  end

  it "should run pending tasks and not raise error" do 
    generate_task("valid_method", %q(
      class ValidMethod < ActiveTask::Task::Base
        execute(:method, :my_method)
        def my_method
          true
        end
      end
    ))

    expect{ ActiveTask::Task.run }.not_to raise_error
  end

  it "should fail to run pending tasks and raise error" do 
    generate_task("invalid_method", %q(
      class InvalidMethod < ActiveTask::Task::Base
        execute(:method, :my_method)
      end
    ))

    expect{ ActiveTask::Task.run }.to raise_error(/method \"my_method\" has not been defined/i)
  end
end