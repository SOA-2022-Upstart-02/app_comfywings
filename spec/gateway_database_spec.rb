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

    it 'HAPPY: should be able to save project from Github to database' do
      currency = ComfyWings::Repository::For.klass(ComfyWings::Entity::Currency).find_code('TWD')

      puts currency
      _(currency.code).must_equal('TWD')
      _(currency.name).must_equal('New Taiwan dollar')
    end

    it 'HAPPY: there should be 3 currencies: TWD USD EUR' do
      reposit = ComfyWings::Repository::For.klass(ComfyWings::Entity::Currency)
      currencies = reposit.all
      _(currencies.size).must_equal(3)
    end
  end
end
