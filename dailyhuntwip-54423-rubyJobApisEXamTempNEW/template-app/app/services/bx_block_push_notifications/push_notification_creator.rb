module BxBlockPushNotifications
  class PushNotificationCreator
    def initialize(notification_params)
      @notification_params = notification_params
    end

    def send
      uri = URI.parse(ENV['NOTIFICATION_URL'])

      http = Net::HTTP.new(uri.host, uri.port)

      http.use_ssl = true
      request = Net::HTTP::Post.new(
        uri.path,
        'Content-Type'  => 'application/json;charset=utf-8'
        #'Authorization' => "Basic" + " " + ENV["REST_API_KEY"]
      )

      request.body = payload_params.as_json.to_json
      http.request(request)
    end

    private

    def ids_array
      id_array = []
      @notification_params[:player_id].each do |key , x|
        id_array <<  "#{x}"
      end
    end

    def payload_params
      # pass player id as array of string
      {
        'app_id' => ENV["ONESIGNAL_APP_ID"],
        'contents' => {'en' => @notification_params[:message]},
        'headings' => {'en' => @notification_params[:title] },
        'app_url' =>  @notification_params[:app_url],
        #"big_picture" => params[:notification][:image] ,
        #"ios_attachments" => params[:notification][:image],
        'include_player_ids' => ids_array
      }
    end
  end
end
