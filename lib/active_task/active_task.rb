module ActiveTask
  # https://stackoverflow.com/a/24151439
  def self.config
    @configuration ||= Configuration.new
  end

  def self.configure
    yield config
  end
  
  def self.table_name
    ActiveTask.config.table_name.to_s.singularize.camelize.freeze
  end

  def self.resource
    table_name.constantize
  end
end