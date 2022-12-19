# frozen_string_literal: true

require 'figaro'
require 'roda'
require 'logger'
require 'rack/session'
require 'delegate'

module ComfyWings
  # Configuration for the App
  class App < Roda
    plugin :environments

    # Environment variables setup
    Figaro.application = Figaro::Application.new(
      environment:,
       path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config = Figaro.env

    use Rack::Session::Cookie, secret: config.SESSION_SECRET

    # Setup for logger
    LOGGER = Logger.new($stderr)
    def self.logger = LOGGER

    configure :development, :test, :app_test do
      require 'pry'; # for breakpoints
    end
  end
end
