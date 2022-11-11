# frozen_string_literal: true

require 'sequel'

module ComfyWings
  module Database
    # Object-Relational Mapper for TripQuery
    class CurrencyOrm < Sequel::Model(:currencies)
      one_to_many :trip_queries,
                  class: :'ComfyWings::Database::TripQueryOrm',
                  key: :currency_id

      def self.find(currency_info)
        first(code: currency_info[:code])
      end
    end
  end
end
