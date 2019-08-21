module ActiveTask
  # https://stackoverflow.com/a/24151439
  def self.config
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end
end