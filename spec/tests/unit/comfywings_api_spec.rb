# frozen_string_literal: true

require_relative '../../helpers/spec_helper'

describe 'Unit test of codePraise API gateway' do
  it 'must report alive status' do
    alive = ComfyWings::Gateway::Api.new(ComfyWings::App.config).alive?
    _(alive).must_equal true
  end

  it 'must be able to return a list of currencies' do
    result = ComfyWings::Gateway::Api.new(ComfyWings::App.config).get_currencies
    _(result.success?).must_equal true
    _(result.parse.count).must_equal 4
  end
end
