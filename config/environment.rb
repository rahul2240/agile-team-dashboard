# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ENV["TROLLOLO_CONFIG_PATH"] = Rails.root.to_s + '/trollolo/.trollolorc'
