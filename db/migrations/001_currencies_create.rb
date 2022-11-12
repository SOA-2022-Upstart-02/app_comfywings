# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:currencies) do
      primary_key :id
      String      :code, unique: true, null: false
      String      :name
    end
  end
end
