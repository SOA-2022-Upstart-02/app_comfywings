# frozen_string_literal: true

require_relative 'airport'

module Views
  # class for list of arrays
  class AirportList
    def initialize(airport_list)
      @list = airport_list.map { |airport_data| Airport.new(airport_data) }
    end

    def each(&)
      @list.each(&)
    end
  end
end
