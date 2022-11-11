# frozen_string_literal: true

require 'sequel'

module ComfyWings
  module Database
    # Object-Relational Mapper for TripQuery
    class TripQueryOrm < Sequel::Model(:trip_queries)
      many_to_one :currencies,
                  class: :'ComfyWings::Database::CurrencyOrm'

      plugin :timestamps, update_on_create: true

      # TODO: Method to convert Ruby Date object into SQL DATE format
      def self.find_or_create(query_info)
        first(code: query_info[:code]) || create(query_info)
      end
    end
  end
end
