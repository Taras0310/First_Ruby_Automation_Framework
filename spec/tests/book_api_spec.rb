require 'spec_helper'
require 'json'
require_relative '../../clients/search_library_client'


RSpec.describe 'SearchLibrary API test' do
  it 'verifies  successfull connection' do
    response = SearchLibraryClient.search_by_few_parametrs(
      title: 'Everything is flammable'
    )
    expect(response.code).to eq(200)
  end

  valid_titles   = ['Everything is flammable', 'EVERYTHING IS FLAMMABLE', 'everything is flammable', 'flammable']
  invalid_titles = [
    SecureRandom.alphanumeric(10),
    SecureRandom.alphanumeric(5),
    'хххх', 
    '|']

  valid_titles.each do |title|
    it " verifies  search by title returns results for '#{title}'" do
      response = SearchLibraryClient.search_by_few_parametrs(
        title: "#{title}"
      )
      data = JSON.parse(response.body)
      expect(data['docs']).not_to be_empty
    end
  end

  invalid_titles.each do |title|
    it "verifies  search by title returns no results for '#{title}'" do
      response = SearchLibraryClient.search_by_few_parametrs(
        title: "#{title}"
      )
      data = JSON.parse(response.body)
      expect(data['docs']).to be_empty
    end
  end

  valid_authors   = ['Rebecca Solnit', 'REBECCA SOLNIT', 'rebecca solnit', 'solnit']
  invalid_authors = [
    SecureRandom.alphanumeric(10),
    SecureRandom.alphanumeric(10),
    'хххх',
     '|']

  valid_authors.each do |author|
    it "verifies search by author returns results for '#{author}'" do
      response = SearchLibraryClient.search_by_few_parametrs(
        author: "#{author}")
      data = JSON.parse(response.body)
      expect(data["docs"]).not_to be_empty
    end
  end

  invalid_authors.each do |author|
    it "verifies search by author returns no results for '#{author}'" do
      response = SearchLibraryClient.search_by_few_parametrs(
        author: "#{author}"
      )
      data = JSON.parse(response.body)
      expect(data["docs"]).to be_empty
    end
  end

  valid_langs   = ['Spa', 'SPA', 'spa', 'sp'] #tests failed


  valid_langs.each do |lang|
    it "verifies search by language returns results for '#{lang}'" do
      response = SearchLibraryClient.search_by_few_parametrs(
        language: "#{lang}"
      )
      data = JSON.parse(response.body)
      expect(data['docs']).not_to be_empty
    end
  end

  it 'verifies search by a few parameters with valid data' do
    response = SearchLibraryClient.search_by_few_parametrs(
      title: 'Everything is flammable',
      author: 'Gabrielle Bell',
      language: 'eng'
    )
    data = JSON.parse(response.body)
    expect(data['docs']).not_to be_empty
  end

  it 'verifies search by a few parameters with invalid data' do
    response = SearchLibraryClient.search_by_few_parametrs(
      title: SecureRandom.alphanumeric(10),
      author: SecureRandom.alphanumeric(10),
      language: SecureRandom.alphanumeric(10)
    )
    data = JSON.parse(response.body)
    expect(data['docs']).to be_empty
  end

  it 'verifies  that response includes required fields after successful search' do
    response = SearchLibraryClient.search_by_few_parametrs(
      author: 'Rebecca Solnit'
    )
    data = JSON.parse(response.body)
    expect(data['docs'].first).to include('title', 'author_name', 'first_publish_year')
  end

  it 'verifies  that response does not include required fields when nvalid  search' do
    response = SearchLibraryClient.search_by_few_parametrs(
      test_parametr: "|"
    )
    data = JSON.parse(response.body)
    expect(data['docs']).to be_empty
  end

  it 'verifies sort search results with a valid sort parameter' do
    response = SearchLibraryClient.sort_search_result(
      'author:Rebecca Solnit', 
      'new'
    )
    data = JSON.parse(response.body)
    expect(data['docs'][-1]['first_publish_year'] < data['docs'][0]['first_publish_year'])
  end

  it 'verifies sort search results with an invalid sort parameter' do
    response = SearchLibraryClient.sort_search_result(
      'author:Rebecca Solnit', 
      SecureRandom.alphanumeric(3)
    )
    expect(response.code).to eq(500)
  end

  it 'verifies search with a valid limit parameter' do
    response = SearchLibraryClient.search_with_limit('author:Solnit', 5)
    data = JSON.parse(response.body)
    expect(data['docs'].size).to be <= 5
  end

  it 'verifies search with a limit parameter < 0' do
    response = SearchLibraryClient.search_with_limit('author:Solnit', -1)
    expect(response.code).to eq(500)
  end
end
