# frozen_string_literal: true

module ComfyWings
  module Repository
    # repository for Airports
    class Airports
      def self.find_id(id)
        rebuild_entity Database::AirportOrm.first(id:)
      end

      def self.find_code(iata_code)
        rebuild_entity Database::AirportOrm.first(iata_code:)
      end

      def self.all
        rebuild_many Database::AirportOrm.all
      end

      def self.first
        Database::AirportOrm.first
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Airport.new(
          id: db_record.id,
          airport_name: db_record.airport_name,
          city_airport_name: db_record.city_airport_name,
          country: db_record.country,
          iata_code: db_record.iata_code
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_member|
          Airports.rebuild_entity(db_member)
        end
      end

      def self.db_find(entity)
        Database::AirportOrm.find(entity.to_attr_hash)
      end
    end
  end
end
