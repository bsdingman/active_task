require "active_task"

describe ActiveTask do
  it "should be configured" do 
    ActiveTask.configure do |c|
      c.table_name = :testing_table
    end

    expect(ActiveTask.config.table_name).to be(:testing_table)
  end

  it "should throw an PendingTask" do
    active_task = ActiveTask::Middleware.new(nil)
    expect{ active_task.check_for_tasks }.to raise_error(ActiveTask::PendingTask)
  end

  it "should be connected to ActiveRecord" do
    expect(ActiveTask::DatabaseConnector.connect).not_to be_nil
  end

  it "should have the task table created" do
    expect(ActiveRecord::Base.connection.table_exists?( ActiveTask.config.table_name)).to be(true)
  end
end