# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

unless Rails.env.production?
  require 'slim_lint/rake_task'

  SlimLint::RakeTask.new
end
