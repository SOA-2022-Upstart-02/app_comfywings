# frozen_string_literal: true

require 'http'
require 'json'
require_relative 'candidate_flight'

# This module is responsible for retaining flight origin and destination information
module Amadeus
  # Library for AMADEUS API
  class AmadeusApi
    AMSDEUS_API_ROOT = 'https://test.api.amadeus.com/'

    def initialize(token, secret)
      @token = token
      @secret = secret
    end

    def obtain_candidate(request_url, search)
      response = call_post_url(request_url, search)
      flight_data = JSON.parse(response)
      CandidateFlight.new(flight_data)
    end

    def flight(from, to, from_date, to_date)
      destinations_to = create_destinations(1, from, to, from_date, '10:00:00')
      destinations_from = create_destinations(2, to, from, to_date, '17:00:00')
      serach = create_filter(destinations_to, destinations_from)
      project_req_url = version2_url_path('shopping/flight-offers')
      obtain_candidate(project_req_url, serach)
    end

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
      # Tap is used to create object instances from classes and we can call their methods after initialisation
      Response.new(result).tap do |response|
        raise(response.error) unless response.successful?
      end
    end

    # class delegator to show errors or success responses
    class Response < SimpleDelegator
      # a class to raise the bad request http error
      BadRequest = Class.new(StandardError)
      # a class that raises the unauthorized http error
      Unauthorized = Class.new(StandardError)
      # a class that raises the unexpected error
      Unexpected = Class.new(StandardError)

      HTTP_ERROR = {
        400 => BadRequest,
        401 => Unauthorized,
        500 => Unexpected
      }.freeze

      def successful?
        !HTTP_ERROR.keys.include?(code)
      end

      def error
        HTTP_ERROR[code]
      end
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
  end
end
