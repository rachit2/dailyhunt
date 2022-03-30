module BxBlockPushNotifications
  class PushNotificationsController < ApplicationController

    def create
      data = BxBlockPushNotifications::PushNotificationCreator.new(
        notification_params
      ).send
      render json: { data: data }
    end

    private

    def notification_params
      params.require(:notification).permit(
        :message, :tag, :title, :app_url, player_id: {}
      )
    end
  end
end
