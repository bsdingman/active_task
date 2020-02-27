# frozen_string_literal: true

describe ActiveTask::Database do
  it "should be connected to ActiveRecord" do
    ActiveTask::Database.connect
    expect(ActiveRecord::Base.connected?).to be(true)
  end

  it "should have the task table created" do
    expect(ActiveRecord::Base.connection.table_exists?(ActiveTask.config.table_name)).to be(true)
  end

  it "should have resource defined" do
    expect(ActiveTask.resource.class).to eq(Class)
  end
end
