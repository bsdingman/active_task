# Active Task (Beta)

*Hey, I'm pulling your code, is there anything I need to run?"*

Sound familar? When working on a team, we all hear it, we all ask it. Active Task answers that question.

Active Task allows developers to create tasks that run Ruby code, Rake tasks, or even system commands. Similar to Active Record, Active Task will throw an error if there are any pending tasks. Once a task has been ran, it will not be ran again on same machine.

### DEVELOPER'S NOTES
- This is my first gem I've written. Even though it has a decent amount of tests, expect bugs. 
- I have not tested this extensively in a team environment (SoonTM)
- I have not tested this in a production environment. (SoonTM)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_task', git: 'https://github.com/bsdingman/active_task.git'
```

And then execute:

    $ bundle install
    $ bundle exec rails g active_task:setup

This will create a file called `active_task.rb` in `config/initializers` and a middleware entry in `config/environments/development.rb`

### Dependencies
- Rails 3 or above

## Usage
### Creating tasks
Tasks can be created by running:

    $ bundle exec rails g active_task:task <NAME>

This will create a new task in `tasks/YYYYMMDDhhmmss_NAME.rb`. It is recommended to check these files into your source control.

### Running tasks 

Now that a task has been created, the next time Rails receives a request, Active Task will throw an exception requiring any pending tasks to be ran. Simply execute the following command in a terminal window:

    $ bundle exec rake active_task:run

### Marking a task complete

In the event a task needs to be manually completed:

    $ bundle exec rake active_task:mark_completed

You will be prompted to enter the **filename** of the task you want to complete.

## Task Types (with examples)
Tasks are defined by using the `execute` method inherited from `ActiveTask::Task::Base`
### Rake Tasks
**Syntax**
```ruby
execute :rake, task_or_tasks_to_run
```

**Examples**

Run Rake Task: "create_llamas"

```ruby
# tasks/xxxxxxxxxxxxxx_create_llamas.rb
class CreateLlamas < ActiveTask::Task::Base
  execute :rake, "create_llamas"
end
```

Run Rake Task "create_llamas" in namespace "farm"
```ruby
# tasks/xxxxxxxxxxxxxx_create_llamas.rb
class CreateLlamas < ActiveTask::Task::Base
  execute :rake, "farm:create_llamas"
end
```
 
Run Rake Task "create_llamas" and "create_cows" in namespace "farm"
```ruby
# tasks/xxxxxxxxxxxxxx_create_llamas_and_cows.rb
class CreateLlamasAndCows < ActiveTask::Task::Base
  execute :rake, "farm:create_llamas", "farm:create_cows"
end
```

**[EXPERIMENTAL]** Respond to user input questions. *(These rake tasks print "How many?" out to the console and expects input back)*
```ruby
# tasks/xxxxxxxxxxxxxx_create_llamas_and_pigs.rb
class CreateLlamasAndPigs < ActiveTask::Task::Base
    execute :rake, "farm:create_llamas": ["5"], "farm:create_pigs": ["2"]
end
```

### Method Calls
**Syntax**
```ruby
execute :method, method_or_methods_to_call
```

**Examples**

Call a method called `my_method` *(Note: Any methods need to be defined in this class)*
```ruby
# tasks/xxxxxxxxxxxxxx_call_my_method.rb
class CallMyMethod < ActiveTask::Task::Base
  execute(:method, :my_method)

  def my_method
    "Do some code here or call other methods"
  end
end
```

Calls methods `my_method` and `another_method`
```ruby
# tasks/xxxxxxxxxxxxxx_call_two_methods.rb
class CallTwoMethods < ActiveTask::Task::Base
  execute(:method, :my_method, :another_method)

  def my_method
    "Some code here"
  end

  def another_method
    "Some code there"
  end
end
```

### System Commands
**Syntax**
```ruby
execute :system, system_command_or_commands
```

**Examples**

Run a python script in home
```ruby
# tasks/xxxxxxxxxxxxxx_party_parrot.rb
class PartyParrot < ActiveTask::Task::Base
  execute :system, "python ~/party_parrot.py"
end
```

Bundle install and Yarn install
```ruby
# tasks/xxxxxxxxxxxxxx_install_deps.rb
class InstallDeps < ActiveTask::Task::Base
  execute :system, "bundle install", "yarn install"
end
```

## Cavats
- There is no "rollback" if a task fails half way through.
- I have not found a reliable way of validating system commands

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rspec spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bsdingman/active_task. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActiveTask project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bsdingman/active_task/blob/master/CODE_OF_CONDUCT.md).
