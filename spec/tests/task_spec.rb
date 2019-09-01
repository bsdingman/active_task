require_relative "../models/test_tasks"

describe ActiveTask::Task::Base do
  describe ValidMethodTask do
    before(:context) do
      @task = ValidMethodTask.instantiate(generate_version)
    end

    it "should be valid" do
      expect(@task.valid?).to be(true)
    end

    it "should have no errors" do 
      expect(@task.errors).to be_empty
    end

    it "should execute" do
      expect{ @task.execute_tasks! }.not_to raise_error
    end

    it "should mark it completed" do 
      @task.mark_as_completed!
      expect(ActiveTask.resource.where(version: @task.version).any?).to be(true)
    end
  end

  describe ValidSystemCommandTask do 
    before(:context) do
      @task = ValidSystemCommandTask.instantiate(generate_version)
    end

    it "should be valid" do
      expect(@task.valid?).to be(true)
    end

    it "should have no errors" do 
      expect(@task.errors).to be_empty
    end

    it "should execute" do
      expect{ @task.execute_tasks! }.not_to raise_error
    end

    it "should mark it completed" do 
      @task.mark_as_completed!
      expect(ActiveTask.resource.where(version: @task.version).any?).to be(true)
    end
  end

  describe ValidRakeTask do 
    before(:context) do
      @task = ValidRakeTask.instantiate(generate_version)
    end

    it "should be valid" do
      expect(@task.valid?).to be(true)
    end

    it "should have no errors" do 
      expect(@task.errors).to be_empty
    end

    it "should execute" do
      expect{ @task.execute_tasks! }.not_to raise_error
    end
    
    it "should mark it completed" do 
      @task.mark_as_completed!
      expect(ActiveTask.resource.where(version: @task.version).any?).to be(true)
    end
  end

  describe FailureMissingMethodTask do
    before(:context) do
      @task = FailureMissingMethodTask.instantiate(generate_version)
    end

    it "should be invalid" do
      expect(@task.valid?).to be(false)
    end

    it "should not have \"my_method\" defined" do 
      expect(@task.errors).to include("Method \"my_method\" has not been defined")
    end

    it "should mark it completed" do 
      @task.mark_as_completed!
      expect(ActiveTask.resource.where(version: @task.version).any?).to be(true)
    end
  end

  describe FailureRaiseExceptionMethodTask do
    before(:context) do
      @task = FailureRaiseExceptionMethodTask.instantiate(generate_version)
    end

    it "should be valid" do
      expect(@task.valid?).to be(true)
    end

    it "should raise an exception" do 
      expect{ @task.execute_tasks! }.to raise_error(/undefined local variable or method/i)
    end

    it "should not be marked as completed" do 
      expect(ActiveTask.resource.where(version: @task.version).any?).to be(false)
    end
  end

  describe FailureRakeTask do
    before(:context) do
      @task = FailureRakeTask.instantiate(generate_version)
    end

    it "should be invalid" do
      expect(@task.valid?).to be(false)
    end

    it "should not have \"test_rake\" defined" do 
      expect(@task.errors).to include("Could not find rake task \"test_rake\"")
    end

    it "should not be marked as completed" do 
      expect(ActiveTask.resource.where(version: @task.version).any?).to be(false)
    end
  end

  describe RakeRaiseExceptionTask do
    before(:context) do
      @task = RakeRaiseExceptionTask.instantiate(generate_version)
    end

    it "should be valid" do
      expect(@task.valid?).to be(true)
    end

    it "should have no errors" do 
      expect(@task.errors).to be_empty
    end

    it "should raise an exception when executing" do
      expect{ @task.execute_tasks! }.to raise_error(/i am an exception\!/i)
    end
    
    it "should not be marked as completed" do 
      expect(ActiveTask.resource.where(version: @task.version).any?).to be(false)
    end
  end
end