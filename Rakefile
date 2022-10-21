# frozen_string_literal: true

require 'rake/testtask'

CODE = 'lib'

task :default do
  puts `rake -T`
end

desc 'run test'
task :spec do
  sh 'ruby spec/anadeus_api_spec.rb'
end

namespace :quality do
  desc 'run all static-analysis quality checks'
  task all: %i[rubocop reek flog]

  desc 'code style linter'
  task :rubocop do
    sh 'rubocop'
  end

  desc 'code smell detector'
  task :reek do
    sh 'reek'
  end

  desc 'complexity analysis'
  task :flog do
    sh "flog #{CODE}"
  end
end