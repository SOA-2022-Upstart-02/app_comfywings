# frozen_string_literal: true

require 'roda'
require 'yaml'
require 'figaro'

module ComfyWings
  # App configuration
  class App < Roda
    plugin :environments

    configure do
      Figaro.application = Figaro::Application.new(
        environment: environment,
        path: File.expand_path('config/secrets.yml')
      )
      Figaro.load

      # Make env variables accessible
      def self.config = Figaro.env
    end
  end
end
