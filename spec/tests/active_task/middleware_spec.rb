describe ActiveTask::Middleware do
  before :context do 
    clear_task_folder
    @middleware = ActiveTask::Middleware.new(->(args) { true })
  end

  after :context do 
    clear_task_folder
  end

  it "should be initialized" do 
    expect(@middleware).not_to be(nil)
  end

  it "should have no pending tasks" do 
    expect{ @middleware.check_for_tasks }.not_to raise_error
  end

  it "should have pending tasks" do
    generate_task("mark_as_completed", %q(
      class MarkAsCompleted < ActiveTask::Task::Base
      end
    ))

    expect{ @middleware.check_for_tasks }.to raise_error("You have pending task(s) that needs completed. Please execute command \"bundle exec rake active_task:run\" to clear this error")
  end
end