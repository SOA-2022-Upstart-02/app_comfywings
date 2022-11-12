# frozen_string_literal: true

require 'date'

module ComfyWings
  module Repository
    # Repository for Trip Queries
    class Currencies
      def self.find_id(id)
        rebuild_entity Database::CurrencyOrm.first(id:)
      end

      def self.find_code(code)
        rebuild_entity Database::CurrencyOrm.first(code:)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Currency.new(
          id: db_record.id,
          code: db_record.code,
          name: db_record.name
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_member|
          Currencies.rebuild_entity(db_member)
        end
      end

      def self.create(entity)
        raise 'currency already exists' if find_code(entity.code)
        
        Database::CurrencyOrm.create(entity.to_attr_hash)
        rebuild_entity(entity)
      end
    end
  end
end
