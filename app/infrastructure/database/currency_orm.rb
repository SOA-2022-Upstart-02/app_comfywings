# frozen_string_literal: true

require 'sequel'

module ComfyWings
  module Database
    # Object-Relational Mapper for TripQuery
    class CurrencyOrm < Sequel::Model(:currencies)
      one_to_many :trip_queries,
                  class: :'ComfyWings::Database::TripQueryOrm',
                  key: :currency_id
      
      # TODO: Method to convert Ruby Date object into SQL DATE format
      def self.find_or_create(currency_info)
        first(code: currency_info[:code]) || create(currency_info)
      end
    end
  end
end