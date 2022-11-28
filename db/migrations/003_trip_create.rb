# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:trips) do
      primary_key :id
      foreign_key :query_id,         :trip_queries
      foreign_key :currency_id,      :currencies
      foreign_key :origin_id,        :airports
      foreign_key :destination_id,   :airports
      String      :outbound_duration
      String      :inbound_duration
      BigDecimal  :price, size: [10, 2]
      TrueClass   :is_one_way
    end
  end
end
