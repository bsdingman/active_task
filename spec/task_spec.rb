require "active_task/task"
require_relative "./models/test_tasks"

describe ActiveTask::Task do
  describe ValidMethodTask do
    it "should be valid" do
      expect(ValidMethodTask.valid?).to be(true)
    end
  end

  describe FailureMethodTask do
    it "should be invalid" do
      expect(FailureMethodTask.valid?).to be(false)
    end

    it "should not have \"my_method\" defined" do 
      expect(FailureMethodTask.errors).to include("Task \"FailureMethodTask\" method task method \"my_method\" has not been defined")
    end
  end

  describe FailureRakeTask do
    it "should be invalid" do
      expect(FailureRakeTask.valid?).to be(false)
    end

    it "should not have \"test_rake\" defined" do 
      expect(FailureRakeTask.errors).to include("Task \"FailureRakeTask\" could not find rake task \"test_rake\"")
    end
  end
end