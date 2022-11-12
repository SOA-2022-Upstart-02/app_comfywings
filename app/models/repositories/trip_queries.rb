# frozen_string_literal: true

require 'date'
require_relative 'currencies'

module ComfyWings
  module Repository
    # Repository for Trip Queries
    class TripQueries
      def self.find(entity)
        find_code(entity.code)
      end

      def self.find_code(code)
        rebuild_entity Database::TripQueryOrm.first(code:)
      end

      def self.create(entity)
        raise 'Query is already exists' if find(entity)

        currency = Currencies.db_find(entity.currency)
        db_trip_query = Database::TripQueryOrm.create(entity.to_attr_hash)
        db_trip_query.update(currency:)
        rebuild_entity(db_trip_query)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::TripQuery.new(
          db_record.to_hash.merge(
            currency: Currencies.rebuild_entity(db_record.currency)
          )
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_member|
          TripQueries.rebuild_entity(db_member)
        end
      end
    end
  end
end
