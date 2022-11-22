# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:trips) do
      primary_key :id
      foreign_key :query_id,    :trip_queries
      foreign_key :currency_id, :currencies
      String      :origin                     # TODO: Change to Airport Table
      String      :destination                # TODO: Change to Airport Table
      String      :outbound_duration
      String      :inbound_duration
      BigDecimal  :price, size: [10, 2]
      TrueClass   :is_one_way
    end
  end
end
