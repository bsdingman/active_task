require_relative "./models/test_tasks"

describe ActiveTask::Task do
  describe ValidMethodTask do
    before(:context) do
      @task = ValidMethodTask.instantiate
    end

    it "should be valid" do
      expect(@task.valid?).to be(true)
    end

    it "should execute" do
      expect{ @task.execute_tasks }.not_to raise_error
    end
  end

  describe FailureMissingMethodTask do
    before(:context) do
      @task = FailureMissingMethodTask.instantiate
    end

    it "should be invalid" do
      expect(@task.valid?).to be(false)
    end

    it "should not have \"my_method\" defined" do 
      expect(@task.errors).to include("Task \"FailureMissingMethodTask\" method task method \"my_method\" has not been defined")
    end
  end

  describe FailureRaiseExceptionMethodTask do
    before(:context) do
      @task = FailureRaiseExceptionMethodTask.instantiate
    end

    it "should be valid" do
      expect(@task.valid?).to be(true)
    end

    it "should raise an exception" do 
      expect{ @task.execute_tasks }.to raise_error()
    end
  end

  describe FailureRakeTask do
    before(:context) do
      @task = FailureRakeTask.instantiate
    end

    it "should be invalid" do
      expect(@task.valid?).to be(false)
    end

    it "should not have \"test_rake\" defined" do 
      expect(@task.errors).to include("Task \"FailureRakeTask\" could not find rake task \"test_rake\"")
    end
  end
end