require "test_helper"

class Scenic::Adapters::SqlServerTest < Minitest::Test
  def setup
    @adapter = Scenic::Adapters::SqlServer.new
  end

  def test_create_view_successfully_creates_a_view
    @adapter.create_view("greetings", "SELECT 'hi' AS greeting")
    assert_includes @adapter.views.map(&:name), "greetings"
  end

  def test_update_view_updates_the_view
    @adapter.create_view("greetings", "SELECT 'hi' AS greeting")
    view = @adapter.views.find { |v| v.name == "greetings" }
    assert_equal "SELECT 'hi' AS greeting", view.definition

    @adapter.update_view("greetings", "SELECT 'hello' AS greeting")
    view = @adapter.views.find { |v| v.name == "greetings" }
    assert_equal "SELECT 'hello' AS greeting", view.definition
  end

  def test_replace_view_raises_an_exception
    @adapter.create_view("greetings", "SELECT 'hi' AS greeting")

    assert_raises Scenic::Adapters::SqlServer::NotSupportedError do
      @adapter.replace_view("greetings", "SELECT text 'hello' AS greeting")
    end
  end

  def test_drop_view_successfully_drops_a_view
    @adapter.create_view("greetings", "SELECT 'hi' AS greeting")
    @adapter.drop_view("greetings")

    refute_includes @adapter.views.map(&:name), "greetings"
  end

  def test_create_materialized_view_raises_an_exception
    assert_raises Scenic::Adapters::SqlServer::NotSupportedError do
      @adapter.create_materialized_view("greetings", "select 1")
    end
  end

  def test_update_materialized_view_raises_an_exception
    assert_raises Scenic::Adapters::SqlServer::NotSupportedError do
      @adapter.update_materialized_view("greetings", "select 1")
    end
  end

  def test_refresh_materialized_view_raises_an_exception
    assert_raises Scenic::Adapters::SqlServer::NotSupportedError do
      @adapter.refresh_materialized_view("greetings")
    end
  end

  def test_drop_materialized_view_raises_an_exception
    assert_raises Scenic::Adapters::SqlServer::NotSupportedError do
      @adapter.drop_materialized_view("greetings")
    end
  end

  def test_view_returns_the_views_defined_on_this_connection
    ActiveRecord::Base.connection.execute <<-SQL
    CREATE VIEW parents AS SELECT 'Joe' AS name
    SQL

    ActiveRecord::Base.connection.execute <<-SQL
    CREATE VIEW children AS SELECT 'Owen' AS name
    SQL

    ActiveRecord::Base.connection.execute <<-SQL
    CREATE VIEW people AS
    SELECT name FROM parents UNION SELECT name FROM children
    SQL

    ActiveRecord::Base.connection.execute <<-SQL
    CREATE VIEW people_with_names AS
    SELECT name FROM people
    WHERE name IS NOT NULL
    SQL

    assert_includes @adapter.views.map(&:name), "parents"
    assert_includes @adapter.views.map(&:name), "children"
    assert_includes @adapter.views.map(&:name), "people"
    assert_includes @adapter.views.map(&:name), "people_with_names"

    assert_equal @adapter.views.find { |v| v.name == "parents" }.materialized, false
    assert_equal @adapter.views.find { |v| v.name == "children" }.materialized, false
    assert_equal @adapter.views.find { |v| v.name == "people" }.materialized, false
    assert_equal @adapter.views.find { |v| v.name == "people_with_names" }.materialized, false
  end
end
