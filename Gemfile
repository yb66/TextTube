RUBY_ENGINE = 'ruby' unless defined? RUBY_ENGINE
source "https://rubygems.org"

gemspec

gem "rake"

group :documentation do
  gem "yard"
  gem "kramdown"
end

group :development do
  unless RUBY_ENGINE == 'jruby' || RUBY_ENGINE == "rbx"
    gem "pry-byebug"
  end
end

group :test do
  gem "rspec"
  gem "simplecov", :require => false
  gem "rspec-its"
end
