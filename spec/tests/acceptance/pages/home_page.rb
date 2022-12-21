# frozen_string_literal: true

#  Page object for home page
class HomePage
  include PageObject

  page_url ComfyWings::App.config.APP_HOST

  h1(:title_heading, id: 'main_header')
  button(:add_button, id: 'flght-form-submit')
end
