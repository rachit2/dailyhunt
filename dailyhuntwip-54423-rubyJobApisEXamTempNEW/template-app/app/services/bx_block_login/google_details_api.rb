# BxBlockLogin::GoogleDetailsApi.call(access_token)
module BxBlockLogin
  module GoogleDetailsApi
    GOOGLE_URL = "https://www.googleapis.com/oauth2/v3/tokeninfo?id_token="

    class << self
      def call(access_token)
        url = "#{GOOGLE_URL}#{access_token}"
        response = HTTParty.get(url)

        if response["error_description"]
          Rails.logger.error response
          {success: false, error: response["error_description"]}
        else
          {success: true, email: response['email'], first_name: "#{response['given_name']} #{response['family_name']}", response: response}
        end
      end
    end
  end
end
