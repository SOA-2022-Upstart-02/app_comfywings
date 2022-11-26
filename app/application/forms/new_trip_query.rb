# frozen_string_literal: true

require 'dry-validation'

module ComfyWings
  module Forms
    MAX_TRAVELERS = 9
    MIN_TRAVELERS = 1

    # From Object for Trip Query from frontend user
    class NewTripQuery < Dry::Validation::Contract
      params do
        required(:airport_origin).filled(:string)
        required(:airport_destination).filled(:string)
        required(:date_start).filled(:date)
        required(:date_end).filled(:date)
        required(:adult_qty).filled(:integer)
        required(:children_qty).filled(:integer)
        # required(:is_one_way).filled(:bool)
        # required(:currency).filled(:string)
      end

      rule(:date_start) do
        key.failure('Must be in the future') if value <= Date.today
      end

      rule(:date_end) do
        key.failure('Must be in the future') if value <= Date.today
      end

      rule(:date_start, :date_end) do
        key.failure('Must be after start date') if values[:date_end] < values[:date_start]
      end

      rule(:adult_qty, :children_qty) do
        if values[:adult_qty] + values[:children_qty] > MAX_TRAVELERS
          key.failure("Maximum number of passengers is #{MAX_TRAVELERS}")
        elsif values[:adult_qty] + values[:children_qty] < MIN_TRAVELERS
          key.failure("Minimum number of passengers is #{MIN_TRAVELERS}")
        end
      end
    end
  end
end
