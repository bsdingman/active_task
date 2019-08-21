require "active_task/task"
require_relative "./models/test_task"

describe ActiveTask::Task do
  it "should be valid?" do
    expect(TestTask.valid?).to be(false)
  end
end