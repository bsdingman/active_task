
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "active_task/version"

Gem::Specification.new do |spec|
  spec.name          = "active_task"
  spec.version       = ActiveTask::VERSION
  spec.authors       = ["Bryan Dingman"]
  spec.email         = ["bsdingman@gmail.com"]

  spec.summary       = %q{Create required tasks}
  spec.description   = %q{Active Task allows teams of developers to ensure required tasks are ran on everyone's computers}
  spec.homepage      = "https://www.github.com/active_task"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rails", '>4.0'

  spec.add_development_dependency "bundler", ">1.17"
  spec.add_development_dependency "byebug", ">10.0"
  spec.add_development_dependency "rake", ">12.0"
  spec.add_development_dependency "rspec", ">3.0"
  spec.add_development_dependency "sqlite3", ">1.4"
  spec.add_development_dependency "yard"
end
