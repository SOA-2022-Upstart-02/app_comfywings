# frozen_string_literal: true

require 'sequel'

module ComfyWings
  module Database
    # Object-Relational Mapper for TripQuery
    class TripQueryOrm < Sequel::Model(:trip_queries)
      many_to_one :currency,
                  class: :'ComfyWings::Database::CurrencyOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
