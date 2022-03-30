module BxBlockBulkUpload
  class EpubService
    class << self

      def create_content(row, content_params, parent_error_tracker=nil)
        content_exist = BxBlockContentmanagement::Content.find_by(id: row[:id])
        if content_exist
          if content_exist.update(epub_params(row, content_params))
            return content_exist
          else
            return { errors: content_exist.errors.full_messages.to_sentence }
          end
        else
          content =  BxBlockContentmanagement::Content.new(epub_params(row, content_params))
          content.save
          if content.errors.present?
            if parent_error_tracker.present?
              parent_error_tracker.add_errors(content.errors.full_messages.to_sentence, row[:heading], row[:sn], 'content', 'heading')
            else
              return {errors: content.errors.full_messages.to_sentence}
            end
          end
          return content
        end
      end

      private

      def epub_params(row, content_params)
        content_params = content_params.merge(publish_date: row[:publish_date], feature_article: row[:feature_article], feature_video: row[:feature_video], is_popular: row[:is_popular], is_trending: row[:is_trending], contentable_attributes: {heading: row[:heading] , description: row[:description]})
        content_params[:contentable_attributes][:pdfs_attributes] =  row[:pdfs_attributes]&.to_unsafe_hash if row[:pdfs_attributes].present?
        content_params
      end
    end
  end
end
