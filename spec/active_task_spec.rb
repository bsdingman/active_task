require "active_task"

describe ActiveTask do
  it "should be configured" do 
    ActiveTask.configure do |c|
      c.table_name = :testing_table
      c.database_yml = File.join(File.expand_path("./spec/config"), "database.yml")
    end

    expect(ActiveTask.config.table_name).to be(:testing_table)
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
end