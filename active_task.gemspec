Gem::Specification.new do |s|
  s.name = %q{active_task}
  s.version = "0.0.0"
  s.authors = ["Bryan Dingman"]
  s.date = %q{2019-08-19}
  s.summary = %q{active_task is the best}
  s.files = [
    "lib/active_task.rb"
  ]
  s.require_paths = ["lib"]
  s.add_runtime_dependency "rails"
  s.add_development_dependency "rspec"
  s.add_development_dependency "byebug"
  s.add_development_dependency "sqlite3"
end