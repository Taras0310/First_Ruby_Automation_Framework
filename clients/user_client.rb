require 'httparty'

class UserLibraryClient
BASE_URL = 'https://petstore.swagger.io/v2/user'

private
 def self.request(type, path = nil, body = {})
    url = path ? "#{BASE_URL}/#{path}" : BASE_URL
    options = {
      headers: { "Content-Type" => "application/json" }
    }
    options[:body] = body.to_json unless body.empty?

    HTTParty.send(type, url, options)
  end

  def self.get_user(username)
    request(:get, username)
  end

  def self.delete_user(username)
    request(:delete, username)
  end

  def self.create_user(body)
    request(:post, nil, body)
  end

  def self.update_user(username, body)
    request(:put, username, body)
  end


end
