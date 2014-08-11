require 'rake/testtask'
require 'ci/reporter/rake/minitest'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

task :test => 'ci:setup:minitest'

desc "Run tests"
task :default => :test