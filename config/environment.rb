require 'roda'
require 'yaml'

module ComfyWings
  # App configuration
  class App < Roda
    CONFIG = YAML.safe_load_file('config/secrets.yml')
    AMADEUS_KEY = CONFIG['AMADEUS_KEY']
    AMADEUS_SECRET = CONFIG['AMADEUS_SECRET']
  end
end