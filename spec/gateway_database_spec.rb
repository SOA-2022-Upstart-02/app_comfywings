# frozen_string_literal: false

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'
require 'securerandom'

describe 'Integration Tests of AMADEUS API and Database' do
  VcrHelper.setup_vcr

  before do
    # Check request body as token and secret are not included in headers
    VcrHelper.configure_vcr_for_amadeus
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve Currency By Currency Code' do
    it 'temp test' do
      code = SecureRandom.uuid
      currency = ComfyWings::Repository::For.klass(ComfyWings::Entity::Currency).find_code('TWD')

      trip_query = ComfyWings::Entity::TripQuery.new(
        id: nil,
        code:,
        currency:,
        origin: 'TPE',
        destination: 'MAD',
        departure_date: Date.parse('2001-02-03'),
        arrival_date: Date.parse('2001-03-03'),
        adult_qty: 1,
        children_qty: 1,
        is_one_way: true
      )

      repository = ComfyWings::Repository::For.klass(ComfyWings::Entity::TripQuery)

      repository.create(trip_query)
      trip_query = repository.find_code(code)
      _(trip_query.origin).must_equal('TPE')
      _(trip_query.currency.name).must_equal('New Taiwan dollar')
    end

    it 'HAPPY: should be able to save project from Github to database' do
      currency = ComfyWings::Repository::For.klass(ComfyWings::Entity::Currency).find_code('TWD')

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
