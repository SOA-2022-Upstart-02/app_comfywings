# frozen_string_literal: true

require 'http'
require 'yaml'
require 'json'

# create auth token class
class AuthToken
  # open secret yaml file
  def initialize(secret_yml_file)
    @config = YAML.safe_load(File.read(secret_yml_file))
  end

  # return the auth token
  def obtain_token
    postform = {
      grant_type: 'client_credentials',
      client_id: @config['development']['AMADEUS_KEY'],
      client_secret: @config['development']['AMADEUS_SECRET']
    }
    response = HTTP.headers(accept: 'application/x-www-form-urlencoded')
      .post(version1_url_path('security/oauth2/token'), form: postform)
    response.parse['access_token']
  end
end

def version1_url_path(path)
  "https://test.api.amadeus.com/v1/#{path}"
end

def version2_url_path(path)
  "https://test.api.amadeus.com/v2/#{path}"
end

origin_destinations_to =
  {
    id: '1',
    originLocationCode: 'TPE',
    destinationLocationCode: 'MAD',
    departureDateTimeRange: {
      date: '2022-11-21',
      time: '10:00:00'
    }
  }
origin_destinations_from =
  {
    id: '2',
    originLocationCode: 'MAD',
    destinationLocationCode: 'TPE',
    departureDateTimeRange: {
      date: '2022-11-28',
      time: '17:00:00'
    }
  }

search = {
  currencyCode: 'USD',
  originDestinations: [origin_destinations_to, origin_destinations_from],
  travelers: [{ id: '1', travelerType: 'ADULT' }],
  sources: ['GDS']
}

token = AuthToken.new('config/secrets.yml')

flight_results = {}

flight_results['count']

response = HTTP.auth("Bearer #{token.obtain_token}").post(version2_url_path('shopping/flight-offers'), json: search)
flight_info = JSON.parse(response)

flight_results['flight_num'] = flight_info['meta']['count']
matched_flights = flight_info['data']

flight_results['flights'] = matched_flights.map do |flight|
  flight_info = {}

  flight_info['seats_num'] = flight['numberOfBookableSeats']
  flight_info['outbound_duration'] = flight['itineraries'][0]['duration']
  flight_info['inbound_duration'] = flight['itineraries'][1]['duration']
  flight_info['total_price'] = flight['price']['total']
  flight_info['origin'] = flight['itineraries'][0]['segments'][0]['departure']['iataCode']
  flight_info['departure_date'] = flight['itineraries'][0]['segments'][0]['departure']['at']
  flight_info['arrival_Date'] = flight['itineraries'][0]['segments'][0]['arrival']['at']
  flight_info['currency_code'] = flight['price']['currency']
  flight_info['currency_name'] = flight['dictionaries']
  flight_info['is_one_way'] = flight['oneWay']
  flight_info
end

File.write('spec/fixtures/flight_results.yml', flight_results.to_yaml)
