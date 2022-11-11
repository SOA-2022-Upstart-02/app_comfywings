# frozen_string_literal: false

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'

describe 'Integration Tests of AMADEUS API and Database' do
  VcrHelper.setup_vcr

  before do
    # Check request body as token and secret are not included in headers
    VcrHelper.configure_vcr_for_amadeus
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store Trip' do
    before do
      DatabaseHelper.wipe_database
    end
  end

  describe 'Retrieve Currency By Currency Code' do
    before do
      DatabaseHelper.wipe_database
    end

    # TODO: Write Your Test There
  end
end
