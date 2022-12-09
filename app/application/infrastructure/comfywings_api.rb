# frozen_string_literal: true

require 'http'
require_relative 'list_request'

module ComfyWings
  module Gateway
    # Infrastructure to call ComfyWings API
    class Api
      def initialize(config)
        @config = config
        @request = Request.new(@config)
      end

      def alive?
        @request.get_root.success?
      end

      def airport(airport_code)
        @request.airport(airport_code)
      end

      # HTTP request transmitter
      class Request

        def initialize(config)
          @api_host = config.API_HOST
          @api_root = config.API_HOST + '/api/v1'
        end

        def get_root # rubocop:disable Naming/AccessorMethodName
          call_api('get')
        end

        def get_airport(req)
          call_api('get', ['airport', req])
        end

        private

        def call_api(method, resources = [])
          api_path = resources.empty? ? @api_host : @api_root
          url = [api_path, resources].flatten.join('/')
          HTTP.headers('Accept' => 'application/json').send(method, url)
            .then { |http_response| Response.new(http_response) }
        end
      end

      # Decorates HTTP responses with success/error
      class Response < SimpleDelegator
        NotFound = Class.new(StandardError)

        SUCCESS_CODES = (200..299).freeze

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
