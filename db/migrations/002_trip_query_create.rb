# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:trip_query) do
      primary_key :id
      foreign_key :currency_id, :currency
      String      :origin
      String      :destination
      Date        :departure_date
      Date        :arrival_date
      Integer     :adult_qty
      Integer     :children_qty
      TrueClass   :is_one_way
      String      :code, unique: true, null: false # generate by 8 bit uuid
    end
  end
end
