require 'simplecov'
SimpleCov.start 'rails'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :mocha
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
