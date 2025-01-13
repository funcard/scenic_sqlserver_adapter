ENV["RAILS_ENV"] = "test"
require "database_cleaner"
require "bundler/setup"
require "scenic_sqlserver_adapter"
require "activerecord-sqlserver-adapter"
require "scenic"

ActiveRecord::Base.establish_connection(
  adapter: "sqlserver",
  database: "scenic_test",
  host: "localhost",
  port: 1433,
  username: "SA",
  password: "yourStrongPassword123"
)

RSpec.configure do |config|
  config.order = "random"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  DatabaseCleaner.strategy = :transaction

  config.around(:each) do |example|
    DatabaseCleaner.start
    example.run
    DatabaseCleaner.clean
  end
end
