# frozen_string_literal: true

require 'dry-validation'

module ComfyWings
  module Forms
    # From Object for Trip Query from frontend user
    class NewTripQuery < Dry::Validation::Contract
      params do
        required(:airport_origin).filled(:string)
        required(:airport_destination).filled(:string)
        required(:date_start).filled(:date)
        required(:date_end)
        required(:adult_qty).filled(:integer)
        required(:children_qty).filled(:integer)
        required(:currency).filled(:string)
        required(:is_one_way).filled(:bool)
      end
    end
  end
end
