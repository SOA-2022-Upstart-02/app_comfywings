# frozen_string_literal: true

require 'sequel'

module ComfyWings
  module Database
    # Object-Relational Mapper for TripQuery
    class CurrencyOrm < Sequel::Model(:currencies)
      one_to_many :trip_queries,
                  class: :'ComfyWings::Database::TripQueryOrm',
                  key: :currency_id

      plugin :timestamps, update_on_create: true
      
      # TODO: Method to convert Ruby Date object into SQL DATE format
    end
  end
end