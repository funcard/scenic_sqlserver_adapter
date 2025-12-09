ENV["RAILS_ENV"] = "test"
require "bundler/setup"
require "scenic_sqlserver_adapter"
require "activerecord-sqlserver-adapter"
require "scenic"

ActiveRecord::Base.establish_connection(
  adapter: "sqlserver",
  # database: "scenic_test",
  host: "localhost",
  port: 1433,
  username: "SA",
  password: "yourStrongPassword123"
)

class Minitest::Test
  # Runs before each test
  def setup
    super

    @adapter = Scenic::Adapters::SqlServer.new
    @adapter.drop_view("children")
    @adapter.drop_view("greetings")
    @adapter.drop_view("parents")
    @adapter.drop_view("people")
    @adapter.drop_view("people_with_names")
  end

  # Runs after each test
  def teardown
    @adapter = Scenic::Adapters::SqlServer.new
    @adapter.drop_view("children")
    @adapter.drop_view("greetings")
    @adapter.drop_view("parents")
    @adapter.drop_view("people")
    @adapter.drop_view("people_with_names")

    super
  end
end
