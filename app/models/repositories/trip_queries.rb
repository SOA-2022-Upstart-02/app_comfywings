# frozen_string_literal: true

require 'date'

module CodePraise
  module Repository
    # Repository for Trip Queries
    class TripQueries
      def self.find_id(id)
        rebuild_entity Database::TripQueryOrm.first(id:)
      end

      def self.find_code(code)
        rebuild_entity Database::TripQueryOrm.first(code:)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::TripQuery.new(
          id: db_record.id,
          code: db_record.code,
          currency_code: db_record.currency_id, # TODO: find a way to convert to code and name
          currency_name: db_record.currency_id,
          origin: db_record.origin,
          destination: db_record.destination,
          departure_date: Date.parse(db_record.departure_date),
          arrival_date: Date.parse(db_record.arrival_date),
          adult_qty: db_record.adult_qty,
          children_qty: db_record.children_qty,
          is_one_way: db_record.is_one_way,
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_member|
          TripQueries.rebuild_entity(db_member)
        end
      end

      def self.db_find_or_create(entity)
        Database::TripQueryOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end