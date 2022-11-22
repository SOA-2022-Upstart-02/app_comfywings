# frozen_string_literal: true

require 'http'
require 'json'
require 'yaml'
require_relative 'auth_token'

# airport token
new_t = AuthToken.new('config/secrets.yml')

DEPATURE = 'TPE'

request_response = HTTP.auth("Bearer #{new_t.obtain_token}")
  .get(version1_url_path("airport/direct-destinations?departureAirportCode=#{DEPATURE}"))
airport_info = JSON.parse(request_response)

airport_results = {}
airport_results['count']

# airport results
airport_results['num_of_airport'] = airport_info['meta']['count']
obtained_airports = airport_info['data']

airport_results['airports'] = obtained_airports.map do |airport|
  airport_info = {}
  airport_info['info_type'] = airport['type']
  airport_info['area'] = airport['subtype']
  airport_info['city_name'] = airport['name']
  airport_info['city_code'] = airport['iataCode']
  airport_info
end

File.write('spec/fixtures/airport_results.yml', airport_results.to_yaml)
