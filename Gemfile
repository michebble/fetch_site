# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

ruby "3.2.2"

group :development do
  gem "standardrb", "~> 1.0"
  gem "debug", "~> 1.8"
end

group :test do
  gem "rspec", "~> 3.12"
  gem "vcr", "~> 6.2"
  gem "webmock", "~> 3.19"
end
