# frozen_string_literal: true

require 'http'
require 'json'
require_relative 'candidate_flight'

# This module is responsible for retaining flight origin and destination information
module Amadeus
  # Library for AMADEUS API
  class AmadeusApi
    AMSDEUS_API_ROOT = 'https://test.api.amadeus.com/'

    # This module is responsible for creating classed that raise http errors
    module Errors
      # a class to raise the bad request http error
      class BadRequest < StandardError; end
      # a class that raises the unauthorized http error
      class Unauthorized < StandardError; end
      # a class that raises the unexpected error
      class Unexpected < StandardError; end
    end

    HTTP_ERROR = {
      400 => Errors::BadRequest,
      401 => Errors::Unauthorized,
      500 => Errors::Unexpected
    }.freeze

    def initialize(token, secret)
      @token = token
      @secret = secret
    end

    def flight(from, to, from_date, to_date)
      destinations_to = create_destinations(1, from, to, from_date, '10:00:00')
      destinations_from = create_destinations(2, to, from, to_date, '17:00:00')
      serach = create_filter(destinations_to, destinations_from)
      project_req_url = amadeus_api_path_v2('shopping/flight-offers')
      response = call_post_url(project_req_url, serach)
      flight_data = JSON.parse(response)
      CandidateFlight.new(flight_data)
    end

    private

    def version1_url_path(path)
      "#{AMSDEUS_API_ROOT}/v1/#{path}"
    end

    def version2_url_path(path)
      "#{AMSDEUS_API_ROOT}/v2/#{path}"
    end

    def call_post_url(url, content)
      token = request_amadeus_auth_token
      result =
        HTTP.headers(accept: 'application/vnd.amadeus+json')
            .auth("Bearer #{token}")
            .post(url, json: content)

      successful?(result) ? result : raise(HTTP_ERROR[result.code])
    end

    def request_amadeus_auth_token
      postform = {
        grant_type: 'client_credentials',
        client_id: @token,
        client_secret: @secret
      }

      response = HTTP.headers(accept: 'application/x-www-form-urlencoded')
                     .post(version1_url_path('security/oauth2/token'), form: postform)
      response.parse['access_token']
    end

    def create_destinations(id, from, to, date, time)
      {
        id:,
        originLocationCode: from,
        destinationLocationCode: to,
        departureDateTimeRange: {
          date:,
          time:
        }
      }
    end

    def create_filter(origin_destinations_to, origin_destinations_from)
      {
        currencyCode: 'USD',
        originDestinations: [origin_destinations_to, origin_destinations_from],
        travelers: [{ id: '1', travelerType: 'ADULT' }],
        sources: ['GDS']
      }
    end

    def successful?(result)
      !HTTP_ERROR.keys.include?(result.code)
    end
  end
end
