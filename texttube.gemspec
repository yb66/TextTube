# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "texttube/version"

Gem::Specification.new do |s|
  s.name           = "texttube"
  s.summary        = "Create chainable filters with ease."
  s.description 	 = s.summary
  s.version        = TextTube::VERSION
  s.platform       = Gem::Platform::RUBY
  s.required_ruby_version    = ">= 1.9.1"
  s.author         = "Iain Barnett"
  s.files          = `git ls-files`.split("\n")
  s.email          = "iainspeed @nospam@ gmail.com"
  s.test_files     = `git ls-files -- {test,spec,features}`.split("\n")
  s.homepage       = "https://github.com/yb66/TextTube"
end
