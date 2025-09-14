require 'spec_helper'
require 'json'
require_relative '../../clients/search_library_client'


RSpec.describe 'SearchLibrary API test' do
  it 'Check successfull connection' do
    response = SearchLibraryClient.search_by_title('Everything is flammable')
    expect(response.code).to eq(200)
  end

  valid_titles   = ['Everything is flammable', 'EVERYTHING IS FLAMMABLE', 'everything is flammable', 'flammable']
  invalid_titles = ['хххх', '|']

  valid_titles.each do |title|
    it "Search by title returns results for '#{title}'" do
      response = SearchLibraryClient.search_by_title(title)
      data = JSON.parse(response.body)
      expect(data["docs"]).not_to be_empty
    end
  end

  invalid_titles.each do |title|
    it "Search by title returns no results for '#{title}'" do
      response = SearchLibraryClient.search_by_title(title)
      data = JSON.parse(response.body)
      expect(data["docs"]).to be_empty
    end
  end

  valid_authors   = ['Rebecca Solnit', 'REBECCA SOLNIT', 'rebecca solnit', 'solnit']
  invalid_authors = ['хххх', '|']

  valid_authors.each do |author|
    it "Search by author returns results for '#{author}'" do
      response = SearchLibraryClient.search_by_author(author)
      data = JSON.parse(response.body)
      expect(data["docs"]).not_to be_empty
    end
  end

  invalid_authors.each do |author|
    it "Search by author returns no results for '#{author}'" do
      response = SearchLibraryClient.search_by_author(author)
      data = JSON.parse(response.body)
      expect(data["docs"]).to be_empty
    end
  end

  valid_langs   = ['Spa', 'SPA', 'spa', 'sp'] #tests failed
  invalid_langs = ['хххх', '|']

  valid_langs.each do |lang|
    it "Search by language returns results for '#{lang}'" do
      response = SearchLibraryClient.search_by_language(lang)
      data = JSON.parse(response.body)
      expect(data["docs"]).not_to be_empty
    end
  end

  invalid_langs.each do |lang|
    it "Search by language returns no results for '#{lang}'" do
      response = SearchLibraryClient.search_by_language(lang)
      data = JSON.parse(response.body)
      expect(data["docs"]).to be_empty
    end
  end

  it 'Search by a few parameters with valid data' do
    response = SearchLibraryClient.search_by_few_parametrs(
      title: 'Everything is flammable',
      author: 'Gabrielle Bell',
      language: 'eng'
    )
    data = JSON.parse(response.body)
    expect(data["docs"]).not_to be_empty
  end

  it 'Search by a few parameters with invalid data' do
    response = SearchLibraryClient.search_by_few_parametrs(
      title: 'ss',
      author: 'kk',
      language: 'll'
    )
    data = JSON.parse(response.body)
    expect(data["docs"]).to be_empty
  end

  it 'Response includes required fields after successful search' do
    response = SearchLibraryClient.search_by_author('Rebecca Solnit')
    data = JSON.parse(response.body)
    expect(data["docs"].first).to include("title", "author_name", "first_publish_year")
  end

  it 'Response does not include required fields when nvalid  search' do
    response = SearchLibraryClient.search_by_language("|")
    data = JSON.parse(response.body)
    expect(data["docs"]).to be_empty
  end

  it 'Sort search results with a valid sort parameter' do
    response = SearchLibraryClient.sort_search_result("author:Rebecca Solnit", "new")
    data = JSON.parse(response.body)
    expect(data["docs"][-1]["first_publish_year"] < data["docs"][0]["first_publish_year"])
  end

  it 'Sort search results with an invalid sort parameter' do
    response = SearchLibraryClient.sort_search_result("author:Rebecca Solnit", "t")
    expect(response.code).to eq(500)
  end

  it 'Search with a valid limit parameter' do
    response = SearchLibraryClient.limit_test("author:Solnit", 5)
    data = JSON.parse(response.body)
    expect(data["docs"].size).to be <= 5
  end

  it 'Search with a limit parameter < 0' do
    response = SearchLibraryClient.limit_test("author:Solnit", -1)
    expect(response.code).to eq(500)
  end
end
