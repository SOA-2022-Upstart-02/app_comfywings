# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:trip_queries) do
      primary_key :id
      foreign_key :currency_id, :currencies
      String      :code, unique: true, null: false # generate by 8 bit uuid
      String      :origin
      String      :destination
      Date        :departure_date
      Date        :arrival_date
      Integer     :adult_qty
      Integer     :children_qty
      TrueClass   :one_way
    end
  end
end
