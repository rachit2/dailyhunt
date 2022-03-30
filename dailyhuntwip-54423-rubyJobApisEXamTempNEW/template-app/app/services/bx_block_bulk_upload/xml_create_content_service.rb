# BxBlockBulkUpload::CategoryImportService.call(xlsx, error_tracker)

module BxBlockBulkUpload
  class XmlCreateContentService
    require 'crack'
    require 'uri'
    require 'net/http'
    class << self

      def create_content(create_content_params, response, action)
        content_exist = BxBlockContentmanagement::Content.find_by(crm_id: create_content_params[:crm_id])
        if content_exist
          if content_exist.update(get_content_params(create_content_params, response, action))
            unless content_exist.contentable.images.present?
              if response["ThumbImage"].present?
                contentable_image(response, content_exist)
              end
            end  
            return content_exist
          else
            return { errors: content_exist.errors.full_messages.to_sentence }
          end  
        else
          content =  BxBlockContentmanagement::Content.new(get_content_params(create_content_params, response, action))
          if content.save
            unless content.contentable.images.present?
              if response["ThumbImage"].present?
                contentable_image(response, content)
              end
            end
          end
          if content.errors.present?
            return {errors: content.errors.full_messages.to_sentence}            
          end
          return content
        end
      end

      private

      def get_content_params(create_content_params, response, action)
        create_content_params = create_content_params.merge(publish_date: response["PublishDate"]) if action == "create"
        content_params = create_content_params.merge(feature_article: response["feature_article"], feature_video: response[:feature_video], contentable_attributes: {headline: response["Title"], content: response["Description"] || response["Summary"]})
        content_params
      end

      def contentable_image(response, content)
        image = open(response["ThumbImage"].strip)
        image_name = "#{image.base_uri.to_s.split('/')[-1]}"
        image_path = "#{Rails.root}/app/assets/images/#{image_name}"
        IO.copy_stream(image, image_path)
        content.contentable.images.create(image: Rails.root.join("#{image_path}").open) if content.contentable.present?
        File.delete(image_path) if File.exist?(image_path)
      end
    end
  end
end
