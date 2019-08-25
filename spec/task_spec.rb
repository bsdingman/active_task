require_relative "./models/test_tasks"

describe ActiveTask::Task do
  describe ValidMethodTask do
    it "should be valid" do
      expect(ValidMethodTask.valid?).to be(true)
    end

    it "should execute" do
      expect(ValidMethodTask.execute_tasks)
    end
  end

  describe FailureMissingMethodTask do
    it "should be invalid" do
      expect(FailureMissingMethodTask.valid?).to be(false)
    end

    it "should not have \"my_method\" defined" do 
      expect(FailureMissingMethodTask.errors).to include("Task \"FailureMethodTask\" method task method \"my_method\" has not been defined")
    end
  end

  describe FailureRaiseExceptionMethodTask do
    it "should be valid" do
      expect(FailureRaiseExceptionMethodTask.valid?).to be(true)
    end

    it "should raise an exception" do 
      expect{ FailureRaiseExceptionMethodTask.execute_tasks }.to raise_exception(FailedTask)
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