require "active_record"
require "rails"

module ActiveTask
  class DatabaseConnector
    def self.connect
      ActiveRecord::Base.establish_connection(YAML.load_file(path_to_database_yml)[Rails.env])

      # Create our table to keep track of versions 
      create_table
    end

    private
    def self.path_to_database_yml
      if Rails.env.test?
        File.join(File.expand_path("./config"), "database.yml")
      else
        File.join(Rails.root, "config", "database.yml")
      end
    end

    def self.create_table
      table_name = ActiveTask.config.table_name
      
      ActiveRecord::Schema.define do
        self.verbose = false

        if !table_exists?(table_name)
          create_table(table_name, id: false) do |t|
            t.primary_key :version
          end
        end
      end
    end
  end
end
