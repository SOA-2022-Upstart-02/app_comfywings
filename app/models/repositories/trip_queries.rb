# frozen_string_literal: true

require_relative 'currencies'

module ComfyWings
  module Repository
    # Repository for Trip Queries
    class TripQueries
      def self.find_id(id)
        rebuild_entity Database::TripQueryOrm.first(id:)
      end

      def self.find_origin(origin)
        rebuild_entity Database::TripQueryOrm.first(origin:)
      end

      def self.find(entity)
        find_origin(entity.origin)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        # currency_repository = Repository::For.entity(Entity::Currencies)
        # currency_obj = currency_repository.find_id(db_record.currency_id)

        Entity::TripQuery.new(
          id: db_record.id,
          # code: db_record.code,
          # currency: currency_obj,
          origin: db_record.origin,
          destination: db_record.destination
          # departure_date: Date.parse(db_record.departure_date),
          # arrival_date: Date.parse(db_record.arrival_date),
          # adult_qty: db_record.adult_qty,
          # children_qty: db_record.children_qty,
          # is_one_way: db_record.is_one_way,
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_member|
          TripQueries.rebuild_entity(db_member)
        end
      end

      def self.create(entity)
        raise 'Trip query already exists' if find(entity)
        
        Database::TripQueryOrm.create(entity.to_attr_hash)
        rebuild_entity(entity)
      end
    end
  end
end
