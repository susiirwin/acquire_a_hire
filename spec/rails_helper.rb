ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
end
# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end

Shoulda::Matchers.configure do |config|
 config.integrate do |with|
   with.test_framework :rspec
   with.library :rails
 end
end

def login(user, login_path)
  visit login_path

  fill_in "session_email", with: user.email
  fill_in "session_password", with: user.password

  click_on "Login"
end

def create_professional
  pro = User.new(
    first_name: 'Test',
    last_name: 'Tester',
    business_name: 'Testing',
    email: 'test_tester@testing.com',
    phone: '5555551234',
    street_address: '123 Test st.',
    city: 'Denver',
    state: 'CO',
    zipcode: '80202',
    password: '12345',
    password_confirmation: '12345'
  )
  pro.roles << Role.find_or_create_by(name: 'professional')
  pro.skills << Skill.create(name: 'Professional Skill')
  pro.save
  pro
end

def create_skill(amount = 1)
  amount.times do |n|
    Skill.create(name: "Testing Skill#{n}")
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
