# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)


Gem::Specification.new do |s|
  s.name           = "markdownfilters"
  s.summary        = "Some useful filters for markdown that I use in my blogs"
  s.description = <<-EOF
    Some markdown filters I find useful.
  EOF
  s.version        = "0.2.0"
  s.platform       = Gem::Platform::RUBY
  s.require_paths  << 'ext'
  s.required_ruby_version    = ">= 1.9.1"
  s.author         = "Iain Barnett"
  s.files          = ['Rakefile', 'markdownfilters.gemspec']
  s.files          += Dir['lib/**/*.rb']
  s.add_dependency('hpricot', '>=0.8.4' )
  s.add_dependency('rdiscount', '>=1.6.8' )
  s.email          = "iainspeed @nospam@ gmail.com"
  s.test_files     = Dir.glob('spec/*.rb')
  s.signing_key    = ENV['HOME'] + '/.ssh/gem-private_key.pem'
  s.cert_chain     = [ENV['HOME'] + '/.ssh/gem-public_cert.pem']
end
