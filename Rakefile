# frozen_string_literal: true

require 'rake/testtask'
require_relative 'require_app'

task :default do
  puts `rake -T`
end

desc 'Run unit and integration test'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/tests/{integration, unit}/**/*_spec.rb'
  t.warning = false
end

desc 'Run unit and integration tests'
Rake::TestTask.new(:spec_all) do |t|
  t.pattern = 'spec/tests/**/*_spec.rb'
  t.warning = false
end

desc 'Keep rerunning tests upon changes'
task :respec do
  sh "rerun -c 'rake spec' --ignore 'coverage/*'"
end

namespace :run do
  desc 'Starts app in dev mode (rerun)'
  task :dev do
    sh "rerun -c --ignore 'coverage/*' 'bundle exec puma -p 9292'"
  end

  desc 'Starts app in test mode'
  task :test do
    sh 'RACK_ENV=test bundle exec puma -p 9292'
  end
end


desc 'Run application console'
task :console do
  sh 'pry -r ./load_all'
end

namespace :vcr do
  desc 'Delete cassette fixtures'
  task :wipe do
    sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
      puts(ok ? 'Cassettes deleted successfully.' : 'Cassettes not found.')
    end
  end
end

namespace :quality do
  only_app = 'config/ app/'

  desc 'Run all static-analysis quality checks'
  task all: %i[rubocop reek flog]

  desc 'Only check for unidiomatic code'
  task :rubocop do
    sh 'rubocop'
  end

  desc 'Check for unidiomatic code and safely autocorrect violations.'
  task :rubocop_autocorrect do
    sh 'rubocop --autocorrect'
  end

  desc 'Only check for code smells'
  task :reek do
    sh 'reek'
  end

  desc 'Only analyze code complexity'
  task :flog do
    sh "flog -m #{only_app}"
  end
end

desc 'Update fixtures and wipe VCR cassettes'
task :update_fixtures => 'vcr:wipe' do
  sh 'ruby spec/fixtures/flight_info.rb'
end

desc 'Generate 64-bit session key for Rack::Session'
task :new_session_secret do
  require 'base64'
  require 'securerandom'
  secret = SecureRandom.random_bytes(64).then { Base64.urlsafe_encode64(_1) }
  puts "SESSION_SECRET: #{secret}"
end
