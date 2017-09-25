# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ENV["TROLLOLO_CONFIG_PATH"] = Rails.root.to_s + '/trollolo/.trollolorc'

ENV["GITHUB_USER"] = "example-user"
ENV["GITHUB_EMAIL"] = "example@suse.com"
# Check https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/
ENV["GITHUB_TOKEN"] = "Write here your Github token"
# Check https://developer.github.com/v3/repos/contents/#create-a-file
ENV["GITHUB_API"] = 'https://api.github.com/repos/openSUSE/example-project/contents'
