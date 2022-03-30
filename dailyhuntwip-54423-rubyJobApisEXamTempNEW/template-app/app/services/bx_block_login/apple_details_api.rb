# BxBlockLogin::AppleDetailsApi.call(user_identity, jwt)
module BxBlockLogin
  module AppleDetailsApi
    APPLE_TOKEN_URL = "https://appleid.apple.com/auth/token"
    APPLE_PEM_URL = "https://appleid.apple.com/auth/keys"

    class << self
      def callback(code, id_token)
        params = {
          client_id: ENV['APPLE_CLIENT_ID'],
          client_secret: get_client_secret,
          grant_type: 'authorization_code',
          redirect_uri: ENV['APPLE_REDIRECT_URI'],
          code: code
        }
        encoded_params = URI.encode_www_form(params)
        response = HTTParty.post("#{APPLE_TOKEN_URL}?#{encoded_params}")
        if response.code != 200
          {success: false, error: response["error_description"]}
        else
          jwt_token = response["id_token"]
          token_data = get_token_data(jwt_token)
          {success: true, email: token_data["email"], unique_auth_id: token_data["sub"], response: token_data, type: 'apple'}
        end
      end

      def call(user_identity, jwt)
        begin
          token_data = get_token_data(jwt)
          if token_data.has_key?("sub") && token_data.has_key?("email") && user_identity == token_data["sub"]
            {success: true, email: token_data['email'], unique_auth_id: token_data["sub"], response: token_data, type: 'apple'}
          else
            {success: false, error: 'Your credentails is not correct.'}
          end
        rescue => exception
          {success: false, error: exception}
        end
      end

      private

      def get_token_data(jwt_token)
        header_segment = JSON.parse(Base64.decode64(jwt_token.split(".").first))
        alg = header_segment["alg"]
        kid = header_segment["kid"]

        apple_response = Net::HTTP.get(URI.parse(APPLE_PEM_URL))
        apple_certificate = JSON.parse(apple_response)

        key_hash = ActiveSupport::HashWithIndifferentAccess.new(apple_certificate["keys"].select {|key| key["kid"] == kid}[0])
        jwk = JWT::JWK.import(key_hash)

        token_data = JWT.decode(jwt_token, jwk.public_key, true, {algorithm: alg})[0]
      end

      def get_client_secret
        ecdsa_key = OpenSSL::PKey::EC.new(ENV['APPLE_PEM'])

        headers = {
          'kid' => ENV['APPLE_KEY']
        }

        claims = {
          'iss' => ENV['APPLE_TEAM_ID'],
          'iat' => Time.now.to_i,
          'exp' => Time.now.to_i + 86400*180,
          'aud' => 'https://appleid.apple.com',
          'sub' => ENV['APPLE_CLIENT_ID'],
        }

        token = JWT.encode claims, ecdsa_key, 'ES256', headers
      end
    end
  end
end
