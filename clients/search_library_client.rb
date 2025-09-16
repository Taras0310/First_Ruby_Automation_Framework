require 'httparty'

class SearchLibraryClient
  BASE_URL = 'https://openlibrary.org/search.json'

  def self.search_by_few_parametrs(**args)
    HTTParty.get(BASE_URL, query: args)
  end
  
  def self.sort_search_result(search, sort)
     HTTParty.get(BASE_URL, query: { q: search, sort: sort })
  end
  
  def self.search_with_limit(search, limit)
     HTTParty.get(BASE_URL, query: { q: search, limit: limit })
  end       
end 