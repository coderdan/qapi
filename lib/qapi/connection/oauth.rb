module Qapi
  class Connection::Oauth
    class << self
      attr_accessor :token_url
      attr_accessor :site
    end

    self.token_url = "/oauth/token"

    # New!! Make this generic and don't use an Integration object
    def initialize(key, secret, token:, refresh_token:, expires_at: nil)
      client = OAuth2::Client.new(key, secret, site: self.class.site, token_url: self.class.token_url)
      @access_token = OAuth2::AccessToken.new(client, token, {
        refresh_token: refresh_token,
        expires_at: expires_at,
        mode: :query
      })
    end

    def get(path, query = nil)
      refresh_if_required!
      @access_token.get(path, params: query).tap do |response|
        # TODO: Handle the case where the token expires
        raise Qapi::Error.new(response.body) unless response.status == 200
      end
    end

    protected
      def refresh_if_required!
        if @access_token.expired?
          puts "Refreshing"
          @access_token = @access_token.refresh!
          # FIXME: This only worked for the integration
          @integration.update!(
            token:         @access_token.token,
            refresh_token: @access_token.refresh_token,
            expires_at:    @access_token.expires_at
          )
        end
      end
  end
end
