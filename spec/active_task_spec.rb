require "active_task"

describe ActiveTask do
  it "should throw an PendingTaskError" do
    active_task = ActiveTask::Middleware.new(nil)
    expect{ active_task.check_for_tasks }.to raise_error(ActiveTask::PendingTask)
  end

  it "should be connected" do
    db = ActiveTask::DatabaseConnector.connect
  end
end