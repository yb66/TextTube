require 'rake'
require 'rake/testtask'

lib_dir = File.expand_path('lib')
app_dir = File.expand_path('lib/markdownfilters')
test_dir = File.expand_path('spec')
ext_dir = File.expand_path('lib/markdownfilters/ext')


# desc "Run basic tests"
Spec::Rake::SpecTask.new("test") do |t|
  t.spec_files = FileList['spec/*.rb']
  t.spec_opts = ["-cf", "nested"]
end
