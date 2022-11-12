# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:trip_queries) do
      primary_key :id
      foreign_key :currency_id, :currencies
      String      :origin
      String      :destination
      String      :departure_date
      String      :arrival_date
      String      :is_one_way

      # TODO:
      #String      :code, unique: true, null: false # generate by 8 bit uuid
      #Integer     :adult_qty
      #Integer     :children_qty

    end
  end
end
