# frozen_string_literal: true

require 'http'

module ComfyWings
  module Gateway
    # Infrastructure to call ComfyWings API
    class Api
      def initialize(config)
        @config = config
        @request = Request.new(config)
      end

      def alive?
        @request.get_root.success?
      end

      def get_airport_list(iata_code)
        @request.obtain_airport_list(iata_code)
      end

      def get_airport(iata_code)
        @request.obtain_airport(iata_code)
      end

      def get_currencies
        @request.get_currencies
      end

      def get_trips(code)
        @request.get_trips(code)
      end

      def create_trip_query(trip_query)
        @request.create_trip_query(trip_query)
      end

      # HTTP request transmitter
      class Request
        def initialize(config)
          @api_host = config.API_HOST
          @api_root = "#{config.API_HOST}/api"
        end

        def get_root # rubocop:disable Naming/AccessorMethodName
          call_api('get')
        end

        def get_currencies
          call_api('get', %w[currency all])
        end

        def get_trips(code)
          call_api('get', ['trips', code])
        end

        def create_trip_query(trip_query)
          call_api('post', ['trip_query'], trip_query)
        end

        def obtain_airport(code)
          call_api('get', ['airport', code])
        end

        def obtain_airport_list(code_letter)
          call_api('get', ['airportlist', code_letter])
        end

        def params_str(params)
          params.map { |key, value| "#{key}=#{value}" }.join('&')
            .then { |str| str.empty? ? '' : "?#{str}" }
        end

        def call_api(method, resources = [], params = {})
          api_path = resources.empty? ? @api_host : @api_root
          url = [api_path, resources].flatten.join('/') + params_str(params)
          HTTP.headers('Accept' => 'application/json').send(method, url)
            .then { |http_response| Response.new(http_response) }
        rescue StandardError
          raise "Invalid URL request: #{url}"
        end
      end

      # Decorates HTTP responses with success/error
      class Response < SimpleDelegator
        NotFound = Class.new(StandardError)

        SUCCESS_CODES = (200..299)

        def success?
          code.between?(SUCCESS_CODES.first, SUCCESS_CODES.last)
        end

        def message
          payload['message']
        end

        def payload
          body.to_s
        end
      end
    end
  end
end
