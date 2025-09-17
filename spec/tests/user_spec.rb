# frozen_string_literal: true
require 'spec_helper'
require 'json'
require_relative '../../clients/user_client'
require 'faker'

RSpec.describe 'Describe tests for user' do
  RSpec.shared_examples 'verifies different types of response' do |response, expected_code, tag|
    it "verifies that the test returns #{expected_code}", tag do
      expect(response.code).to eq(expected_code)
    end
  end

  response = UserLibraryClient.send_request(
    :post,
    body: { id: 20005, username: 'tarrik2' }
  )
  include_examples 'verifies different types of response', response, 200, :test_create_user

  response = UserLibraryClient.send_request(
    :get,
    'tarrik2'
  )
  include_examples 'verifies different types of response', response, 200, :test_get_user

  response = UserLibraryClient.send_request(
    :put,
    'taras',
    { id: 20002, username: 'tarrik_new', firstName: 'Taras', lastName: 'Yakushevych' }
  )
  include_examples 'verifies different types of response', response, 200, :test_update_user

  response = UserLibraryClient.send_request(
    :delete,
    'tarrik2'
  )
  include_examples 'verifies different types of response', response, 200, :test_delete_user

  response = UserLibraryClient.send_request(
    :get,
    Faker::Internet.username
  )
  include_examples 'verifies different types of response', response, 404, :test_get_user

  response = UserLibraryClient.send_request(
    :put,
    Faker::Internet.username,
    { id: Faker::Number.number(digits: 10),
      username: Faker::Internet.username,
      firstName: Faker::Name.first_name,
      lastName: Faker::Name.last_name }
  )
  include_examples 'verifies different types of response', response, 404, :test_update_user

  response = UserLibraryClient.send_request(
    :delete,
    Faker::Internet.username
  )
  include_examples 'verifies different types of response', response, 404, :test_delete_user

  response = UserLibraryClient.send_request(
    :post,
    body: Faker::Internet.username
  )
  include_examples 'verifies different types of response', response, 500, :test_create_user

  response = UserLibraryClient.send_request(
    :get,
    ''
  )
  include_examples 'verifies different types of response', response, 405, :test_get_user
end
