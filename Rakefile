# frozen_string_literal: true

require 'rake/testtask'
require_relative 'require_app'

CODE = 'lib/'

task :default do
  puts `rake -T`
end

desc 'Run tests'
task :spec do
  sh 'ruby spec/*_spec.rb'
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

  desc 'Check for unidiomatic code and safely autocorrect violations.'
  task :rubocop_autocorrect do
    sh 'rubocop --autocorrect'
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
