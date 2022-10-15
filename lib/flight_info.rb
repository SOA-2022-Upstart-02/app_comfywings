require 'http'
require 'yaml'
require 'json'

config = YAML.safe_load(File.read('config/secrets.yml'))

def amadeus_api_path_v1(path)
  "https://test.api.amadeus.com/v1/#{path}"
end

def amadeus_api_path_v2(path)
  "https://test.api.amadeus.com/v2/#{path}"
end

def request_amadeus_auth_token(config)
  postform = {
    grant_type: 'client_credentials',
    client_id: config['AMADEUS_KEY'],
    client_secret: config['AMADEUS_SECRET']
  }
  response = HTTP.headers(accept: 'application/x-www-form-urlencoded')
                 .post(amadeus_api_path_v1('security/oauth2/token'), form: postform)
  response.parse['access_token']
end

origin_destinations_to =
  {
    id: '1',
    originLocationCode: 'TPE',
    destinationLocationCode: 'MAD',
    departureDateTimeRange: {
      date: '2022-11-01',
      time: '10:00:00'
    }
  }
origin_destinations_from =
  {
    id: '2',
    originLocationCode: 'MAD',
    destinationLocationCode: 'TPE',
    departureDateTimeRange: {
      date: '2022-11-05',
      time: '17:00:00'
    }
  }

serach = {
  currencyCode: 'USD',
  originDestinations: [origin_destinations_to, origin_destinations_from],
  travelers: [{ id: '1', travelerType: 'ADULT' }],
  sources: ['GDS'],
  searchCriteria: {
    maxFlightOffers: 2,
    flightFilters: {
      cabinRestrictions: [
        {
          cabin: 'BUSINESS',
          coverage: 'MOST_SEGMENTS',
          originDestinationIds: [
            '1'
          ]
        }
      ]
    }
  }
}

token = request_amadeus_auth_token(config)

flight_results = {}

flight_results['count']

response = HTTP.auth("Bearer #{token}").post(amadeus_api_path_v2('shopping/flight-offers'), json: serach)
flight_info = JSON.parse(response)

flight_results['flight_num'] = flight_info['meta']['count']
matched_flights = flight_info['data']
flight_results['flights'] = matched_flights.map do |flight|
  flight_info = {}

  flight_info['seats_num'] = flight['numberOfBookableSeats']
  flight_info['to_duration'] = flight['itineraries'][0]['duration']
  flight_info['from_duration'] = flight['itineraries'][1]['duration']
  flight_info['total_price'] = flight['price']['total']
  flight_info
end

File.write('spec/fixtures/flight_results.yml', flight_results.to_yaml)
