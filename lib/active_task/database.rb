# frozen_string_literal: true

require "active_record"
require "rails"

module ActiveTask
  class Database
    class << self
      attr_accessor :connected
    end

    def self.connect
      ActiveRecord::Base.establish_connection(YAML.load_file(path_to_database_yml)[Rails.env])

      # Create our table to keep track of versions
      create_table

      # Create the ActiveRecord model
      create_model

      @connected = true
    end

    def self.connected?
      !@connected.nil?
    end

    def self.path_to_database_yml
      ActiveTask.config.database_yml
    end

    def self.create_table
      table_name = ActiveTask.config.table_name

      ActiveRecord::Schema.define do
        self.verbose = false

        if !table_exists?(table_name)
          create_table(table_name, id: false) do |t|
            t.string :version
          end

          add_index table_name, :version, unique: true
        end
      end
    end

    def self.create_model
      # Create a new class based on what the user sets in the config
      klass = Class.new(ActiveRecord::Base)
      Object.send(:const_set, ActiveTask.table_name, klass)
    end
  end
end
