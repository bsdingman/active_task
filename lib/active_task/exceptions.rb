# frozen_string_literal: true

module ActiveTask
  module Exceptions
    class InvalidConfig < StandardError; end
    class PendingTask < StandardError; end
    class InvalidTask < StandardError; end
    class InvalidRakeTask < StandardError; end
    class InvalidMethodTask < StandardError; end

    class FailedTask < StandardError
      def initialize(klass, message)
        super("Failed Task #{klass}: #{message}")
      end
    end
  end
end
