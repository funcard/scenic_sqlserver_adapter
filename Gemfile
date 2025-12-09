source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in scenic_sqlserver_adapter.gemspec
gemspec

rails_version = ENV.fetch("RAILS_VERSION", "8.0")

rails_constraint = if rails_version == "main"
  {github: "rails/rails"}
else
  "~> #{rails_version}.0"
end

gem "rails", rails_constraint