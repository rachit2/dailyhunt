# lib/omniauth/facebook.rb

require 'httparty'

module Omniauth
  class Facebook
    include HTTParty

    # The base uri for facebook graph API
    base_uri 'https://graph.facebook.com/v2.3'

    def get_user_profile(access_token)
      options = { query: { access_token: access_token } }
      response = self.class.get('/me', options)

      response.parsed_response
    end
  end
end