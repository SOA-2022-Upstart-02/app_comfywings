# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/home_page'

describe 'Homepage Acceptance Tests' do
  include PageObject::PageFactory

  before do
    @browser = Watir::Browser.new
  end

  after do
    @browser.close
  end

  describe 'Visit Home Page' do
    it 'Happy should not have have any information on the page if no search is made' do
      # visit HomePage do |page|
      #   # see basic hearders
      #   _(page.title_heading).must_equal 'ComfyWings'
      #   _(page.add_button_element.present?).must_equal true
      # end
    end
  end
end
