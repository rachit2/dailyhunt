# BxBlockBulkUpload::CategoryImportService.call(xlsx, error_tracker)

module BxBlockBulkUpload
  class XmlDetailContentService
    require 'crack'
    require 'uri'
    require 'net/http'
    class << self

      def create_content(id)
        content = BxBlockContentmanagement::Content.find_by(id: id)

        if content.present?
          detail_link = content.detail_url
        else
          return { errors: "Can't find content with this id" }
        end  

        if detail_link.present?
          begin
            doc = Nokogiri::XML(open(detail_link.strip))
          rescue Exception => e
            Rails.logger.error(e)
            errors = e
          end
        else
          return { success: false, errors: "didn't find the link" }
        end

        if errors.present?
          return { success: false, errors: "Unable to open the link. " }
        else
          json_response = JSON[Hash.from_xml(doc.to_xml).to_json]

          BxBlockBulkUpload::XmlCreateContentService.create_content(create_content_params(json_response["Data"]["Item"]), json_response["Data"]["Item"], "show")
        end
        return { success: true }
      end

      private

      def create_content_params(json_response)
        {
          crm_id: json_response["ContentId"]
        }
      end
    end
  end
end
