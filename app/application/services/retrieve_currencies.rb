# frozen_string_literal: true

require 'dry/transaction'
require 'digest'

module ComfyWings
  module Service
    # Retrieves array of all currencies
    class RetrieveCurrencies
      include Dry::Transaction

      step :retrieve_all
      step :reify_currencies

      private

      DB_ERR = 'We encountered an issue accessing the database.'

      def retrieve_all
        result = Gateway::Api.new(ComfyWings::App.config).get_currencies
        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot get currencies')
      end

      def reify_currencies(currencies_json)
        Representer::CurrenciesList.new(OpenStruct.new)
          .from_json(currencies_json)
          .then { |currencies| Success(currencies) }
      end
    end
  end
end
