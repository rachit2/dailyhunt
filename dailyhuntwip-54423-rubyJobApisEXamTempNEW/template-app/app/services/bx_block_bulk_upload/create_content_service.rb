# BxBlockBulkUpload::CategoryImportService.call(xlsx, error_tracker)

module BxBlockBulkUpload
  class CreateContentService

    class << self

      def create_content(content_type, sheet_content, sub_category, language, category, tags, admin_user_id, parent_error_tracker=nil)
        case content_type.type
        when "Text"
          BxBlockBulkUpload::TextService.create_content(sheet_content, create_content_params(sheet_content, sub_category.id, language.id, category.id, content_type.id, tags, admin_user_id), content_type.identifier, parent_error_tracker)
        when "Videos"
          BxBlockBulkUpload::VideoService.create_content(sheet_content, create_content_params(sheet_content, sub_category.id, language.id, category.id, content_type.id, tags, admin_user_id), parent_error_tracker)
        when "Live Stream"
          BxBlockBulkUpload::LiveStreamService.create_content(sheet_content, create_content_params(sheet_content, sub_category.id, language.id, category.id, content_type.id, tags, admin_user_id), parent_error_tracker)
        when "AudioPodcast"
          BxBlockBulkUpload::AudioPodcastService.create_content(sheet_content, create_content_params(sheet_content, sub_category.id, language.id, category.id, content_type.id, tags, admin_user_id), parent_error_tracker)
        when "Test"
          BxBlockBulkUpload::TestService.create_content(sheet_content, create_content_params(sheet_content, sub_category.id, language.id, category.id, content_type.id, tags, admin_user_id), parent_error_tracker)
        when "Epub"
          BxBlockBulkUpload::EpubService.create_content(sheet_content, create_content_params(sheet_content, sub_category.id, language.id, category.id, content_type.id, tags, admin_user_id), parent_error_tracker)
        end
      end

      private

      def create_content_params(content, sub_category_id, language_id, category_id, content_type_id, tags, admin_user_id)
        {
          category_id: category_id,
          sub_category_id: sub_category_id,
          language_id: language_id,
          searchable_text: content[:searchable_text],
          content_type_id: content_type_id,
          status: content[:status],
          tag_list: tags,
          admin_user_id: admin_user_id
        }
      end
    end
  end
end
