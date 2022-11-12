# frozen_string_literal: true

require_relative 'trip_queries'
require_relative 'currencies'

module ComfyWings
  module Repository
    # Finds the right repository for an entity object or class
    module For
      ENTITY_REPOSITORY = {
        Entity::TripQuery => TripQueries,
        Entity::Currency => Currencies
      }.freeze

      def self.klass(entity_klass)
        ENTITY_REPOSITORY[entity_klass]
      end

      def self.entity(entity_object)
        ENTITY_REPOSITORY[entity_object.class]
      end
    end
  end
end
