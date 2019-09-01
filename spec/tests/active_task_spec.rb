describe ActiveTask do
  it "should be configured" do 
    expect(ActiveTask.config.table_name).to be(:testing_tables)
  end
end