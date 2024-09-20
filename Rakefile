require 'rake'
require 'rspec/core/rake_task'

task :default => :spec

task :spec => "spec:all"
namespace :spec do
  host = ENV['TARGET_HOST'] || '10.0.209.40'

  task :all => [:services, :configuration]

  desc 'run configuration tests'
  RSpec::Core::RakeTask.new(:configuration) do |t|
    puts "Running configuration tests on #{host} ..."
    t.pattern = "spec/configuration/*_spec.rb"
    t.rspec_opts = "--format documentation"  # O "--format progress"
  end

  desc 'run service tests'
  RSpec::Core::RakeTask.new(:services) do |t|
    puts "Running service tests on #{host} ..."
    t.pattern = "spec/services/*_spec.rb"
    t.rspec_opts = "--format documentation"  # O "--format progress"
  end
end