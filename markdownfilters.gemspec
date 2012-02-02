# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "markdownfilters/version"

Gem::Specification.new do |s|
  s.name           = "markdownfilters"
  s.summary        = "Some useful filters for markdown that I use in my blogs"
  s.description = <<-EOF
    Some markdown filters I find useful.
  EOF
  s.version        = MarkdownFilters::VERSION
  s.platform       = Gem::Platform::RUBY
  s.required_ruby_version    = ">= 1.9.1"
  s.author         = "Iain Barnett"
  s.files          = `git ls-files`.split("\n")
  s.add_dependency("hpricot", '~>0.8.4' )
  s.add_dependency("rdiscount", '~>1.6.8' )
  s.add_dependency("coderay", '~>1.0' )
  s.email          = "iainspeed @nospam@ gmail.com"
  s.test_files     = `git ls-files -- {test,spec,features}`.split("\n")
end
