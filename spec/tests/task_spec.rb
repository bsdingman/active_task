describe ActiveTask::Task do
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

  it "should mark it completed" do 
    task_name = generate_task("mark_as_completed", %q(
      class MarkAsCompleted < ActiveTask::Task::Base
      end
    ))

    ActiveTask::Task.mark_completed(task_name)

    expect(ActiveTask.resource.where(version: parse_version_from_task_name(task_name)).first).not_to be(nil)
  end
end