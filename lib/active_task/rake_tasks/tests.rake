namespace :active_task_testing do
  desc "(tests) Is valid rake"
  task valid: :environment do
    true
  end

  desc "(tests) Is another valid rake"
  task another_valid: :environment do
    true
  end

  desc "(tests) Is valid rake with arguments"
  task valid_args: :environment do
    response = STDIN.gets.chomp
    raise "Expected 1, got #{response}" if response != "1"
    response = STDIN.gets.chomp
    raise "Expected 2, got #{response}" if response != "2"
  end

  desc "(tests) Is Invalid, raises exception"
  task raise_exception: :environment do 
    raise Exception.new("I am an exception!")
  end
end