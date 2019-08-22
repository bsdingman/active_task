require "active_task/task"
require_relative "./models/test_tasks"

describe ActiveTask::Task do
  describe FailureMethodTask do
    it "should be invalid" do
      expect(FailureMethodTask.valid?).to be(false)
    end

    it "should have 1 error" do 
      expect(FailureMethodTask.errors).to include("Task \"FailureMethodTask\" method task method \"my_method\" has not been defined")
    end
  end

  describe FailureCommandtask do
    it "FailureCommandtask should be valid?" do
      expect(FailureCommandtask.valid?).to be(false)
    end
  end
end