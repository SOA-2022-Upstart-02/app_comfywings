#  frozen_string_literal: true

require 'json'
require 'dry/monads'
require 'base64'

module ComfyWings
  module Gateway
    module Value
      # List request parser
      class WatchedList
        include Dry::Monads::Result::Mixin

        # Use in client App to create params to send
        def self.to_encoded(list)
          Base64.urlsafe_encode64(list.to_json)
        end

        # Use in tests to create a WatchedList object from a list
        def self.to_request(list)
          WatchedList.new('list' => to_encoded(list))
        end
      end
    end
  end
end
