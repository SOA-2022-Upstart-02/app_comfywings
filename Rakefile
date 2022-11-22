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

desc 'Starts web app'
task :run do
  sh 'bundle exec puma'
end

desc 'Reruns web app upon changes'
task :rerun do
  sh "rerun -c --ignore 'coverage/*' --ignore 'repostore/*' -- bundle exec puma"
end

namespace :db do
  task :config do
    require 'sequel'
    require_relative 'config/environment' # load config info
    require_relative 'spec/helpers/database_helper'

    def app = ComfyWings::App
  end

  desc 'Run migrations'
  task :migrate => :config do
    Sequel.extension :migration
    puts "Migrating #{app.environment} database to latest"
    Sequel::Migrator.run(app.DB, 'db/migrations')
  end

  desc 'Wipe records from all tables'
  task :wipe => :config do
    if app.environment == :production
      puts 'Do not damage production database!'
      return
    end

    require_app('infrastructure')
    DatabaseHelper.wipe_database
  end

  desc 'Delete dev or test database file (set correct RACK_ENV)'
  task :drop => :config do
    if app.environment == :production
      puts 'Do not damage production database!'
      return
    end

    FileUtils.rm(ComfyWings::App.config.DB_FILENAME)
    puts "Deleted #{ComfyWings::App.config.DB_FILENAME}"
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
