module ActiveTask
  module Task
    module Internal
      class FileTask
        attr_reader :version, :file_path, :name

        def initialize(file_path)
          match = file_path.match(/(\d{14})_(.*)\.rb$/i)
          @file_path = file_path
          @version = match[1]
          @name = match[2]
        end
      end
    end
  end
end