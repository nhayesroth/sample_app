# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# Configure logger
Rails.logger = ActiveSupport::Logger.new(STDOUT)
Rails.logger.level = Logger::INFO