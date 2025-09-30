require 'httparty'

class SearchLibraryClient
  BASE_URL = 'https://openlibrary.org/search.json'

  def self.search_by_parameters(params = {})
    HTTParty.get(BASE_URL, query: params)
  end
end 
