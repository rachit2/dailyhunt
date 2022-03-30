# BxBlockLogin::GoogleDetailsApi.call(access_token)
module BxBlockLogin
  module LinkedinDetailsApi
    LINKEDIN_URL = "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))&oauth2_access_token="
    LINKEDIN_PROFILE_URL = "https://api.linkedin.com/v2/me?projection=(id,firstName,lastName)&oauth2_access_token="
    ACCESS_TOKEN_URL = "https://www.linkedin.com/oauth/v2/accessToken"

    class << self

      def call(code)
        response = get_access_token(code)
        if response.code != 200 
          {success: false, error: response["error_description"]}
        else
          get_details(response["access_token"])
        end
      end

      def get_details(access_token)
        url = "#{LINKEDIN_URL}#{access_token}"
        profile_url = "#{LINKEDIN_PROFILE_URL}#{access_token}"
        response = HTTParty.get(url)
        profile_response = HTTParty.get(profile_url)
        if response.code != 200 || profile_response.code != 200
          Rails.logger.error response
          {success: false, error: response["message"] || profile_response["message"]}
        else
          {success: true, email: response['elements'][0]['handle~']['emailAddress'], first_name: "#{profile_response["firstName"]["localized"].values.first} #{profile_response["lastName"]["localized"].values.first}", response: response}
        end
      end

      def get_access_token(code)
        params = {
          grant_type: 'authorization_code',
          code: code,
          redirect_uri: ENV['LINKEDIN_REDIRECT_URL'],
          client_id: ENV['CLIENT_ID'],
          client_secret: ENV['CLIENT_SECRET']
        }
        encoded_params = URI.encode_www_form(params)
        url = "#{ACCESS_TOKEN_URL}?#{encoded_params}"
        response = HTTParty.get(url)
      end

    end
  end
end
