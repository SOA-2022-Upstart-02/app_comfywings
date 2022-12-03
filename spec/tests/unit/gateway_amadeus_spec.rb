# frozen_string_literal: true

require_relative '../../spec_helper'
require_relative '../../helpers/vcr_helper'

CORRECT_TRIP = CORRECT['flights'][0]

describe 'Tests AMADEUS API library' do
  VcrHelper.setup_vcr

  before do
    # Check request body as token and secret are not included in headers
    VcrHelper.configure_vcr_for_amadeus
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Token generator' do
    before do
      @token = AuthToken.new
    end
    it 'It should create a new auth token' do
      _(@token.obtain_token).wont_be_nil
    end
  end

  describe 'Error responses' do
    it 'Bad: should raise exception when unauthorised' do
      _(proc do
        ComfyWings::Amadeus::Api
        .new('BAD_TOKEN', 'BAD_SECRET').airport_data(DEPATURE)
      end).must_raise ComfyWings::Amadeus::Api::Response::Unauthorized
    end

    it 'Bad: Should raise exception incorrect data' do
      _(proc do
        ComfyWings::Amadeus::Api
        .new(AMADEUS_KEY, AMADEUS_SECRET).airport_data('XYZ')
      end).must_raise ComfyWings::Amadeus::Api::Response::BadRequest
    end

    it 'Bad: Should raise exception when data is longer than 3 charactaers' do
      _(proc do
          ComfyWings::Amadeus::Api
          .new(AMADEUS_KEY, AMADEUS_SECRET).airport_data('Invalid_Length')
        end).must_raise ComfyWings::Amadeus::Api::Response::BadRequest
    end
  end
end
