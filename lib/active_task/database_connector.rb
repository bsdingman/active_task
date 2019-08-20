require "active_record"
require "rails"

module ActiveTask
  class DatabaseConnector
    def self.connect
      ActiveRecord::Base.establish_connection(YAML.load_file(path_to_database_yml)[Rails.env])
    end

    private
    def self.path_to_database_yml
      if Rails.env.test?
        File.join(File.expand_path("./config"), "database.yml")
      else
        File.join(Rails.root, "config", "database.yml")
      end
    end
  end
end
