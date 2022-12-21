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
    configure do
      # Environment variables setup
      Figaro.application = Figaro::Application.new(
        environment:,
        path: File.expand_path('config/secrets.yml')
      )
      Figaro.load

      # Setup for logger
      LOGGER = Logger.new($stderr)
      def self.logger = LOGGER

      use Rack::Session::Cookie, secret: config.SESSION_SECRET

      # Logger setup
      def self.logger = Logger.new($stderr)

      configure :development, :test, :app_test do
        require 'pry'
      end
    end
  end
end
