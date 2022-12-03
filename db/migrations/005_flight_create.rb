# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:flights) do
      primary_key    :id
      foreign_key    :trip_id,        :trips
      foreign_key    :origin_id,      :airports
      foreign_key    :destination_id, :airports
      Time           :departure_time
      Time           :arrival_time
      String         :aircraft
      String         :number
      String         :duration
      String         :cabin_class
      TrueClass      :is_return
    end
  end
end
