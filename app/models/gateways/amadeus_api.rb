# frozen_string_literal: true

require 'http'
require 'json'
require_relative '../candidate_flight'

module ComfyWings
  # Library for AMADEUS API
  module Amadeus
    # API For Amadeus
    class Api
      def initialize(key, secret)
        @key = key
        @secret = secret
      end

      def trip_data(from, to, from_date, to_date)
        destinations_to = create_destinations(1, from, to, from_date, '10:00:00')
        destinations_from = create_destinations(2, to, from, to_date, '17:00:00')
        search = create_filter(destinations_to, destinations_from)
        response = Request.new(@key, @secret).trip(search)
        flight_data = JSON.parse(response)
        flight_data['data']
      end

      private

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

      # class to make HTTP request
      class Request
        AMADEUS_API_ROOT = 'https://test.api.amadeus.com'

        def initialize(key, secret)
          @key = key
          @secret = secret
        end

        def trip(content)
          url = version2_url_path('shopping/flight-offers')
          http_response = HTTP.headers(accept: 'application/vnd.amadeus+json')
                              .auth("Bearer #{request_amadeus_auth_token}")
                              .post(url, json: content)

          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end

        private

        def version1_url_path(path)
          "#{AMADEUS_API_ROOT}/v1/#{path}"
        end

        def version2_url_path(path)
          "#{AMADEUS_API_ROOT}/v2/#{path}"
        end

        # TODO: store the access token and only request it when token is expired
        def request_amadeus_auth_token
          postform = {
            grant_type: 'client_credentials',
            client_id: @key,
            client_secret: @secret
          }
          response = HTTP.headers(accept: 'application/x-www-form-urlencoded')
                         .post(version1_url_path('security/oauth2/token'), form: postform)
          response.parse['access_token']
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
    end
  end
end
