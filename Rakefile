# encoding: UTF-8

desc "(Re-) generate documentation and place it in the docs/ dir."
task :docs => :"docs:yard"  
namespace :docs do
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    t.files   = ['lib/**/*.rb']
    t.options = ['-odocs/', '--no-private']
  end

  desc "Docs including private methods."
  YARD::Rake::YardocTask.new(:all) do |t|
    t.files   = ['lib/**/*.rb']
    t.options = ['-odocs/']
  end
    
  desc "How to use the docs."
  task :usage do
    puts "Open the index.html file in the docs directory to read them. Does not include methods marked private unless you ran the 'all' version (you'll only need these if you plan to hack on the library itself)."
  end
end


task :default => "spec"

task :spec => :"spec:run"
task :rspec => :spec
namespace :spec do
  task :environment do
    ENV["RACK_ENV"] = "test"
  end

  desc "Run specs"
  task :run, [:any_args] => :"spec:environment" do |t,args|
    warn "Entering spec task."
    any_args = args[:any_args] || ""
    cmd = "bin/rspec #{any_args}"
    warn cmd
    system cmd
  end

end