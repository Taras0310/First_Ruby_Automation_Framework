require 'httparty'

class UserLibraryClient
  BASE_URL = 'https://petstore.swagger.io/v2/user'

  def self.create_new_user(parametrs = {})
    HTTParty.post(BASE_URL,  
       body: parametrs.to_json,
       headers: { "Content-Type" => "application/json" }
    )
  end

  def self.get_user(username)
    HTTParty.get("#{BASE_URL}/#{username}")
  end

  def self.update_user(username, parametrs = {})
    HTTParty.put("#{BASE_URL}/#{username}",
      body: parametrs.to_json,
      headers: { "Content-Type" => "application/json" }
    )
  end

  def self.delete_user(username)
    HTTParty.delete("#{BASE_URL}/#{username}")
  end
end