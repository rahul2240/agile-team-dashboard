source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use postgresql as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma'

# Use SCSS for stylesheets
gem 'sass-rails'
gem 'semantic-ui-sass'

gem 'coffee-rails'
gem 'uglifier', '>= 1.3.0'

gem 'therubyracer', platforms: :ruby

gem 'devise'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'turbolinks', '~> 5'

gem 'jbuilder', '~> 2.5'

gem 'holidays'
gem 'kaminari'
gem 'slim'
gem 'slim-rails'
gem 'simple_form'

gem 'pundit'
gem 'fullcalendar-rails'
gem 'momentjs-rails'
gem 'active_hash'
gem 'country_select'
gem 'flag-icon-sass'

gem 'identicon'
gem 'redcarpet'

gem 'trollolo', '>= 0.1.1'
gem 'clockwork'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :test do
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'launchy'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'capybara'
  gem 'poltergeist'
  gem 'phantomjs', require: 'phantomjs/poltergeist'
  gem 'timecop'
  # for test coverage reports
  gem 'codecov', require: false
  gem 'simplecov', require: false
  # for checking commit messages
  gem 'git-cop'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rubocop', require: false
  # for property tests
  gem 'rantly'
  gem 'faker'
  gem 'slim_lint'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %>
  # anywhere in the code.
  gem 'web-console', '>= 3.3.0'

  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running
  # in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'annotate', git: 'https://github.com/ctran/annotate_models.git'
  gem 'mina'
end

group :production do
  # passenger for apache2
  gem "passenger", ">= 5.0.25", require: "phusion_passenger/rack_handler"
end
