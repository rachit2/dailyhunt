require './lib/omniauth/facebook.rb'

# BxBlockLogin::FacebookDetailsApi.call(access_token)
module BxBlockLogin
  module FacebookDetailsApi
    class << self
      def call(access_token)
        res = Omniauth::Facebook.new.get_user_profile(access_token)

        if res['error']
          Rails.logger.error res
          {success: false, error: res['error']['message']}
        else
          url = get_url(res['id'], access_token)
          response = HTTParty.get(url)

          {success: true, email: response['email'], first_name: "#{res['name']}", response: response}
        end
      end

      private
      def get_url(response_id, access_token)
        "https://graph.facebook.com/#{response_id}?fields=email&access_token=#{access_token}"
      end
    end
  end
end
