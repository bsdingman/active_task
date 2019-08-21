module ActiveTask
  class PendingTask < StandardError; end
  class InvalidTask < StandardError; end
  class InvalidRakeTask < StandardError; end
  class InvalidCommandTask < StandardError; end
  class InvalidMethodTask < StandardError; end

  class FailedTask < StandardError
    def initialize(klass, message)
      super("Failed Task #{klass}: #{message}")
    end
  end
end