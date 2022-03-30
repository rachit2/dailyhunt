module BxBlockBulkUpload
  class TestService
    class << self

      def create_content(row, content_params, parent_error_tracker=nil)
        content_exist = BxBlockContentmanagement::Content.find_by(id: row[:id])
        if content_exist
          if content_exist.update(test_params(row, content_params))
            return content_exist
          else
            return {errors: content_exist.errors.full_messages.to_sentence}
          end
        else
          content =  BxBlockContentmanagement::Content.new(test_params(row, content_params))
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

      def test_params(row, content_params)
        content_params.merge(publish_date: row[:publish_date], feature_article: row[:feature_article], feature_video: row[:feature_video], is_popular: row[:is_popular], is_trending: row[:is_trending], contentable_attributes: {headline: row[:heading], description: row[:description]})
      end
    end
  end
end
