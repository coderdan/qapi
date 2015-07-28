module Qapi
  class Connection
    class << self
      attr_accessor :token_url
      attr_accessor :site
    end

    self.token_url = "/oauth/token"

    # TODO: Make this generic and don't use an Integration object
    # OR we could create a value object inside Qapi
    # @param [Integration] integration model
    def initialize(key, secret, integration)
      @integration = integration
      client = OAuth2::Client.new(key, secret, site: self.class.site, token_url: self.class.token_url)
      @access_token = OAuth2::AccessToken.new(client, integration.token, {
        refresh_token: integration.refresh_token,
        expires_at: integration.expires_at,
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
          @access_token = @access_token.refresh!
          @integration.update!(
            token:         @access_token.token,
            refresh_token: @access_token.refresh_token,
            expires_at:    @access_token.expires_at
          )
        end
      end
  end
end
