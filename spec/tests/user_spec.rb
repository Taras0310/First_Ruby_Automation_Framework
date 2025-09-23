# frozen_string_literal: true
require 'spec_helper'
require 'json'
require_relative '../../clients/user_client'
require 'faker'

RSpec.shared_examples 'verifies response code' do |expected_code|
  it "returns #{expected_code}" do
    expect(response.code).to eq(expected_code)
  end
end

RSpec.describe 'API requests for user' do
  let(:new_user_id) { 200055 }
  let(:new_username) { 'tarrik22' }
  let(:existing_username) { 'tarrik' }
  let(:invalid_username) { Faker::Internet.username }
  let(:update_user_id) { 2000056 }
  let(:first_name) { 'Taras' }
  let(:last_name) { 'Yakushevych' }
  let(:update_user_name) { 'tarrik_new' }
  let(:invalid_first_name) { Faker::Name.first_name }
  let(:invalid_last_name) { Faker::Name.last_name }
  let(:invalid_id) { Faker::Number.number(digits: 10) }

  context 'POST /user', :test_create_user do
    let(:response) { UserLibraryClient.create_user(body: { id: new_user_id, username: new_username }) }
    it_behaves_like 'verifies response code', 200
  end

  context 'GET /user', :test_get_user do
    let(:response) { UserLibraryClient.get_user(existing_username) }
    it_behaves_like 'verifies response code', 200
  end

  context 'PUT /user', :test_update_user do
    let(:response) do
      UserLibraryClient.update_user(
        existing_username,
        body: { id: update_user_id, username: update_user_name, firstName: first_name, lastName: last_name }
      )
    end
    it_behaves_like 'verifies response code', 200
  end

  context 'DELETE /user', :test_delete_user do
    let(:response) { UserLibraryClient.delete_user(existing_username) }
    it_behaves_like 'verifies response code', 200
  end

  context 'GET non-existent user', :test_get_user do
    let(:response) { UserLibraryClient.get_user(invalid_username) }
    it_behaves_like 'verifies response code', 404
  end

  context 'PUT non-existent user', :test_update_user do
    let(:response) do
      UserLibraryClient.update_user(
        invalid_username,
        body: { id: invalid_id, username: invalid_username, firstName: invalid_first_name, lastName: invalid_last_name }
      )
    end
    it_behaves_like 'verifies response code', 404
  end

  context 'DELETE non-existent user', :test_delete_user do
    let(:response) { UserLibraryClient.delete_user(invalid_username) }
    it_behaves_like 'verifies response code', 404
  end

  context 'POST with invalid body', :test_create_user do
    let(:response) { UserLibraryClient.create_user(body: { fake: invalid_username }) }
    it_behaves_like 'verifies response code', 500
  end

  context 'GET empty username', :test_get_user do
    let(:response) { UserLibraryClient.get_user('') }
    it_behaves_like 'verifies response code', 405
  end
end
