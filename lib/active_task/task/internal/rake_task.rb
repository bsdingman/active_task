require "byebug"
module ActiveTask
  module Task
    module Internal
      class RakeTask
        def self.invoke(rake_task, arguments: [])
          if arguments.any?
            invoke_rake_with_args(rake_task, arguments)
          else
            invoke_rake(rake_task)
          end
        end

        private
        def self.invoke_rake(rake_task)
          Rake::Task[rake_task].invoke
        end

        def self.invoke_rake_with_args(rake_task, arguments)
          # Invoke rake task and respond to any input requests from the rake
          # https://stackoverflow.com/a/18475405

          # create a pipe
          read_io, write_io = IO.pipe

          child = fork do
            # close the write end of the pipe
            write_io.close

            # change our stdin to be the read end of the pipe
            STDIN.reopen(read_io)

            # exec the desired command which will keep the stdin just set
            invoke_rake(rake_task)
          end

          # close read end of pipe
          read_io.close

          # write what we want to the pipe, it will be sent to childs stdin
          arguments.each do |argument|
            # The new line character will "Submit" our response
            write_io.write("#{argument}\n")
          end
          
          # Close the write pipe
          write_io.close

          # Wait for the rake task to exit
          Process.wait(child)

          # We can get the last exit code from $?.exitstatus. A failed rake task will not return 0
          raise Exception.new if $?.exitstatus != 0
        end
      end
    end
  end
end