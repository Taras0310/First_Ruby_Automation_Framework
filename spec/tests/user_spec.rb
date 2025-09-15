
require 'spec_helper'
require 'json'
require_relative '../../clients/user_client'

=begin
RSpec.describe 'Describe tests for user' do
  it 'Create user with a valid data',  :test_create_user, :valid do
    response = UserLibraryClient.create_new_user(
      id: 20005,
      username: 'tarrik2'
    )

    expect(response.code).to eq(200)
  end

  it 'Create user with the invalid input parametrs',  :test_create_user, :invalid do
    response = UserLibraryClient.create_new_user(
    "ttt"
    )

    expect(response.code).to eq(500)
  end
  
  it 'Get user by username with existing username', :test_get_user, :valid do
    response = UserLibraryClient.get_user("tarrik")

    expect(response.code).to eq(200)
  end

  it 'Get user by username with non existing username', :test_get_user,  :invalid do
    response = UserLibraryClient.get_user("tarrik3")

    expect(response.code).to eq(404)
  end

  it 'Get user by username with an empty username', :test_get_user, :invalid do
    response = UserLibraryClient.get_user("")

    expect(response.code).to eq(405)
  end

  it 'Update user with a valid data', :test_update_user, :valid do
      response = UserLibraryClient.update_user("taras", 
      id: 20002,
      username: 'tarrik_new',
      firstName: "Taras",
      lastName: "Yakushevych",
      )

    expect(response.code).to eq(200)
  end
 
    it 'Update user with the invalid data', :test_update_user, :invalid do
        response = UserLibraryClient.update_user("nonexistent_user_999", 
        id: 99999,
        username: 'non exist',
        firstName: "non",
        lastName: "non",
        )
      p response.code
      expect(response.code).to eq(404)
    end
  
   it 'Delete user with a valid data', :test_delete_user, :valid  do 
     response = UserLibraryClient.delete_user("tarrik2")

    expect(response.code).to eq(200)
   end

  it 'Delete user with the invalid data', :test_delete_user, :invalid  do 
     response = UserLibraryClient.delete_user("tarrik1")

    expect(response.code).to eq(404)
   end
end
=end


RSpec.describe 'Describe tests for user' do
  RSpec.shared_examples '200 status code test' do |response, tag|
    it 'Returns 200 status', :valid, tag do
      expect(response.code).to eq(200)
    end
  end

  RSpec.shared_examples '404 status code test' do |response, tag|
    it 'Returns 404 status', :invalid, tag do
      expect(response.code).to eq(404)
    end
  end

  RSpec.shared_examples 'Other types of response test' do |response, expected_code, tag|
    it 'Returns #{expected_code}', :invalid, tag do
      expect(response.code).to eq(expected_code)
    end
  end


  response = UserLibraryClient.create_new_user(id: 20005, username: 'tarrik2')
  include_examples '200 status code test', response, :test_create_user

  response = UserLibraryClient.get_user('tarrik2')
  include_examples '200 status code test', response, :test_get_user

  response = UserLibraryClient.update_user(
    'taras',
    id: 20002,
    username: 'tarrik_new',
    firstName: 'Taras',
    lastName: 'Yakushevych'
  )
  include_examples '200 status code test', response, :test_update_user

  response = UserLibraryClient.delete_user('tarrik2')
  include_examples '200 status code test', response, :test_delete_user

  
  response = UserLibraryClient.get_user('tarrik3')
  include_examples '404 status code test', response, :test_get_user

#failed
  response = UserLibraryClient.update_user( 
    'nonexistent_user',
    id: 99999,
    username: 'non exist',
    firstName: 'non',
    lastName: 'non'
  )
  include_examples '404 status code test', response, :test_update_user

  response = UserLibraryClient.delete_user('tarrik1')
  include_examples '404 status code test', response, :test_delete_user

  response = UserLibraryClient.create_new_user('ttt')
  include_examples  'Other types of response test', response, 500, :test_create_user

  response = UserLibraryClient.get_user('')
  include_examples 'Other types of response test', response, 405, :test_get_user
end

