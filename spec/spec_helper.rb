# encoding: UTF-8

unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path.to_str)
    end
  end
end

# code coverage
require 'simplecov'
SimpleCov.start do
  add_filter "/vendor/"
  add_filter "/bin/"
  add_filter "/spec/"
end

require 'rspec'

Spec_dir = File.expand_path( File.dirname __FILE__ )


Dir[ File.join( Spec_dir, "/support/**/*.rb")].each do |f| 
  logger.info "requiring #{f}"
  require f
end


RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
end

