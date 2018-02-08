# frozen_string_literal: true

# SimpleCov configuration
SimpleCov.start 'rails' do
  ENV['CODECOV_FLAG'] = ENV['TEST_SUITE']
  merge_timeout 3600
  formatter SimpleCov::Formatter::Codecov
end
