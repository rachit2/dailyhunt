module BxBlockContentmanagement
  class ContentProviderSerializer < BuilderBase::BaseSerializer
    attributes :id, :email, :partner_name, :logo, :created_at, :updated_at

    attribute :follow do |object, params|
      params && params[:current_user_id] && current_user_following(object, params[:current_user_id])
    end


    attribute :logo do |object|
      object.logo if object.logo.present?
    end

    class << self
      private
      def current_user_following(record, current_user_id)
        record.follows.where(account_id: current_user_id).present?
      end
    end

    attribute :count do |object, params|
      params[:count][object.id] if params && params[:count]
    end
  end
end
