# frozen_string_literal: true

require 'rake/testtask'

CODE = 'lib/'

task :default do
  puts `rake -T`
end

desc 'Run tests'
task :spec do
  sh 'ruby spec/gateway_amadeus_api_spec.rb'
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
  desc 'Run all quality checks'
  task all: %i[rubocop reek flog]

  desc 'Only check for unidiomatic code'
  task :rubocop do
    sh 'rubocop'
  end

  desc 'Only check for code smells'
  task :reek do
    sh 'reek'
  end

  desc 'Only check for code complexity'
  task :flog do
    sh "flog #{CODE}"
  end
end

desc 'Starts web app'
task :run do
  sh 'bundle exec puma'
end