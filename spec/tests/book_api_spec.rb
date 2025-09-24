# frozen_string_literal: true
require 'spec_helper'
require 'json'
require_relative '../../clients/search_library_client'

RSpec.shared_examples 'verifies response code for SearchLibrary API' do |expected_code|
  it "returns #{expected_code}" do
    expect(response.code).to eq(expected_code)
  end
end

RSpec.shared_examples 'verifies empty search results' do
  it 'returns no search results' do
    data = JSON.parse(response.body)
    expect(data['docs']).to be_empty
  end
end

RSpec.shared_examples 'verifies search results' do
  it 'returns search results' do
    data = JSON.parse(response.body)
    expect(data['docs']).not_to be_empty
  end
end

RSpec.describe 'SearchLibrary API test' do
  context 'test connectiob', :test_connection do
    let(:response) { SearchLibraryClient.search_by_parameters( title: 'Everything is flammable') }
    it_behaves_like 'verifies response code for SearchLibrary API', 200
  end


  ## just sample values to verify search by different title cases
  valid_titles   = ['Everything is flammable', 'EVERYTHING IS FLAMMABLE', 'everything is flammable', 'flammable']
  invalid_titles = [SecureRandom.alphanumeric(10), '|']

  valid_titles.each do |title|
    context 'test search with a valid title', :test_valid do
      let(:response) { SearchLibraryClient.search_by_parameters({title: title}) }
      it_behaves_like 'verifies search results'
    end
  end

  invalid_titles.each do |title|
    context 'test search with  invalid title', :test_invalid do
      let(:response) { SearchLibraryClient.search_by_parameters({title: title}) }
      it_behaves_like 'verifies empty search results'
    end
  end

  valid_authors = ['Rebecca Solnit', 'REBECCA SOLNIT', 'rebecca solnit', 'solnit']
  invalid_authors = [SecureRandom.alphanumeric(10),'хххх','|']

  valid_authors.each do |author|
    context 'test search with a valid author name', :test_valid do
      let(:response) { SearchLibraryClient.search_by_parameters({author: author}) }
      it_behaves_like 'verifies search results'
    end
  end

  invalid_authors.each do |author|
    context 'test search with a invalid author name', :test_invalid do
      let(:response) { SearchLibraryClient.search_by_parameters({author: author}) }
      it_behaves_like 'verifies empty search results'
    end
  end

  valid_langs   = ['Spa', 'sp'] #tests failed


  valid_langs.each do |lang|
   context 'test search with a valid language parameter', :test_valid do
      let(:response) { SearchLibraryClient.search_by_parameters({language: lang}) }
      it_behaves_like 'verifies search results'
    end
  end

  context 'test search  by a few parameters with valid data', :test_valid do
      let(:response) { SearchLibraryClient.search_by_parameters({title: 'f' , sort: 'new'}) }
      it_behaves_like 'verifies search results'
    end

  context 'test search  by a few parameters with invalid data', :test_invalid do
      let(:response) { SearchLibraryClient.search_by_parameters({
          title: SecureRandom.alphanumeric(10),
          author: SecureRandom.alphanumeric(10),
          language: SecureRandom.alphanumeric(10)
        }
      ) 
    }
      
      it_behaves_like 'verifies search results'
    end
  
  context 'verify that response includes required files' do
    let(:response) { SearchLibraryClient.search_by_parameters({author: 'Rebecca Solnit'}) }
    let(:data) { JSON.parse(response.body) }

    it 'verify that response includes required fields' do
      expect(data['docs'].first).to include('title', 'author_name', 'first_publish_year')
    end
end

  context 'verify that response does not  includes required files when search is invalid' do
    let(:response) { SearchLibraryClient.search_by_parameters({ test_parametr: "|" }) }

    it_behaves_like 'verifies empty search results'
  end

  context 'when sorting search results with a valid sort parameter' do
    let(:response) { SearchLibraryClient.search_by_parameters({ author: 'Rebecca Solnit', sort: 'new' }) }
    let(:data) { JSON.parse(response.body) }

    it 'verify sorts results by publish year descending' do
      expect(data['docs'][-1]['first_publish_year'] < data['docs'][0]['first_publish_year']).to be true
    end
  end

  context 'verify sorting search results with an invalid sort parameter' do
    let(:response) { SearchLibraryClient.search_by_parameters({author: 'Rebecca Solnit', sort: SecureRandom.alphanumeric(3)}) }
    it_behaves_like 'verifies response code for SearchLibrary API', 500
  end
  
  valid_limit_parameter = Array.new(1) { rand(1..1000) }
  invalid_limit_parameter = [-1, 0, 'abc', 1001]

  valid_limit_parameter.each do | parameter |
    context "verify search with a valid limit value #{parameter}", :test_valid do
      let(:response) { SearchLibraryClient.search_by_parameters({ author: 'Solnit', limit: parameter }) }
      let(:data) { JSON.parse(response.body) }

      it 'verify search with a valid limit parameter' do
        expect(data['docs'].size).to be <= parameter
      end
    end
  end

  invalid_limit_parameter.each do | parameter |
    context "verify search with a valid limit value #{parameter}", :test_invalid do
      let(:response) { SearchLibraryClient.search_by_parameters({ author: 'Solnit', limit: parameter }) }
      let(:data) { JSON.parse(response.body) }

      it 'verify search with a valid limit parameter' do
       expect([400, 500]).to include(response.code)
      end
    end
  end
end

