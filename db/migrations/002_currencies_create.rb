# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:currencies) do
      primary_key :id
      String      :code, unique: true, null: false # generate by 8 bit uuid
      String      :name
    end
  end
end
