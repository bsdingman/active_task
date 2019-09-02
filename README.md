# Active Task

*Hey, I'm pulling your code, is there anything I need to run?"*

Sound familar? When working on a team, we all hear it, we all ask it. Active Task answers that question.

Active Task allows developers to create tasks that run Ruby code, Rake tasks, or even system commands. Similar to Active Record, Active Task will throw an error if there are any pending tasks. Once a task has been ran, its timestamp will recorded in the database so it does not get processed again. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_task'
```

And then execute:

    $ bundle install
    $ bundle exec rails g active_task:config

This will create a file called `active_task.rb` in `config/initializers` and a middleware entry in `config/environments/development.rb`

### Dependencies
- Rails 3 or above

## Usage
Active Task uses Active Record like migrations called tasks. 

Tasks can be created by running:

    $ bundle exec rails g active_task:task <NAME>

This will create a task with the timestamp and name in `tasks/`. It is recommended to check these files into your source control.

Now that a task has been created, the next time Rails receives a request, Active Task will throw an exception requiring any pending tasks to be ran. Simply run in a terminal window:

    $ bundle exec rake active_task:run

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rspec spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bsdingman/active_task. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActiveTask project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bsdingman/active_task/blob/master/CODE_OF_CONDUCT.md).
