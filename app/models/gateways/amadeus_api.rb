# frozen_string_literal: true

require 'http'
require 'json'

# This module is responsible for retaining flight origin and destination information
module ComfyWings
  # Library for AMADEUS API
  module Amadeus
    #library for amadeus api
    class Api
      AMADEUS_API_ROOT = 'https://test.api.amadeus.com'

      def initialize(token, secret)
        @api_key = token
        @api_secret = secret
      end

      def airport(departure)
        project_req_url = version1_url_path("airport/direct-destinations?departureAirportCode=#{departure}")
        response = call_get_url(project_req_url)
        airport_data = JSON.parse(response)
      end

      def airport_size(depart)
        airports_size = airport(depart)
        return airports_size['meta']['count']
      end

      def airport_data(depart)
        airports_data = airport(depart)
        return airports_data['data']
      end

      def call_get_url(url)
        responses = Request.new(AMADEUS_API_ROOT, @api_key, @api_secret)
        result = HTTP.headers(accept: 'application/json')
                     .auth("Bearer #{responses.request_amadeus_auth_token}").get(url)
        # Tap is used to create object instances from classes and we can call their methods after initialisation
        Response.new(result).tap do |response|
          raise(response.error) unless response.successful?
        end
      end

      # class to make HTTP request
      class Request
        def initialize(root, token, secret)
          @root = root
          @token = token
          @new_secret = secret
        end

        def version1_url_path(path)
          "#{AMADEUS_API_ROOT}/v1/#{path}"
        end

        def version2_url_path(path)
          "#{AMADEUS_API_ROOT}/v2/#{path}"
        end

        def request_amadeus_auth_token
          postform = {
            grant_type: 'client_credentials',
            client_id: @token,
            client_secret: @new_secret
          }
          response = HTTP.post(version1_url_path('security/oauth2/token'), form: postform)
          response.parse['access_token']
        end
      end

      # class delegator to show errors or success responses
      class Response < SimpleDelegator
        # a class to raise the data missing http error
        BadRequest = Class.new(StandardError)
        # a class that raises the not found http error
        Unauthorized = Class.new(StandardError)
        # a class that raises the unexpected/system error
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
