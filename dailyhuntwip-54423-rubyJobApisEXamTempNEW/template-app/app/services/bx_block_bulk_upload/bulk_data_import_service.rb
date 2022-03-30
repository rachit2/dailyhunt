module BxBlockBulkUpload
  class BulkDataImportService
    def store_data(xlsx, current_user_id)
      error_tracker = ErrorTracker.new

      BxBlockBulkUpload::CategoryImportService.call(xlsx, error_tracker)
      BxBlockBulkUpload::SubCategoryImportService.call(xlsx, error_tracker)
      BxBlockBulkUpload::ContentImportService.call(xlsx, error_tracker, current_user_id)
      BxBlockBulkUpload::PartnerImportService.call(xlsx, error_tracker)

      if error_tracker.success?
        return {success: true}
      else
        return {success: false, errors: error_tracker.get_errors}
      end
    end
  end
end
