require 'httparty'

class UserLibraryClient

private
def self.send_request(type, username = nil, body = {})
  url = 'https://petstore.swagger.io/v2/user'
  case type
  when :get
    HTTParty.get("#{url}/#{username}")
  when :delete
    HTTParty.delete("#{url}/#{username}")
  when :post 
     HTTParty.post(url,  
       body: body.to_json,
       headers: { "Content-Type" => "application/json" }
    )
  when :put
    HTTParty.put("#{url}/#{username}",
      body: body.to_json,
      headers: { "Content-Type" => "application/json" }
    )
  else
    raise "Invalid HTTP method type"
  end
 end
end
