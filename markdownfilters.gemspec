# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)


Gem::Specification.new do |s|
  s.name           = "MarkdownFilters"
  s.summary        = "Some useful filters for markdown that I use in my blogs"
  s.description = <<-EOF
    RandomPerson is a port to Ruby of Perl's Data::RandomPerson. Use it to generate random persons given various parameters, such as country, age and gender ratio.
  EOF
  s.version        = "0.0.1"
  s.platform       = Gem::Platform::RUBY
  s.require_paths  << 'ext'
  s.required_ruby_version    = ">= 1.9.1"
  s.author         = "Iain Barnett"
  s.files          = ['Rakefile', 'markdownfilters.gemspec']
  s.files          += Dir['lib/**/*.rb']
  s.email          = "iainspeed @nospam@ gmail.com"
  s.test_files     = Dir.glob('spec/*.rb')
  s.signing_key    = ENV['HOME'] + '/.ssh/gem-private_key.pem'
  s.cert_chain     = [ENV['HOME'] + '/.ssh/gem-public_cert.pem']
end
