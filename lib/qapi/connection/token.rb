module Qapi
  class Connection::Token
    class << self
      attr_accessor :host
      attr_accessor :token_name
    end

    self.token_name = 'access_key'

    # New!! Make this generic and don't use an Integration object
    def initialize(access_token)
      @access_token = access_token
    end

    def get(path, query = {})
      conn.get(path, auth_params.merge(query)).tap do |response|
        raise Qapi::Error.new(response.body) unless response.status == 200
      end
    end

    def conn
      @conn ||= Faraday.new(url: self.class.host).tap do |conn|
        conn.headers['Content-Type'] = 'application/json'
      end
    end

    def auth_params
      { self.class.token_name => @access_token }
    end
  end
end
