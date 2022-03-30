module BxBlockContentmanagement
  class ContentImportService
    def store_content_data(content_data)
      contents_arr = []
      success, missing_headers = validate_headers(content_data.first, model_name)
      unless success
        return {success: false, error: "missing headers: #{missing_headers} in content sheet"}
      end
      content_data.each(headers(model_name)) do |row|
        contents_arr << row
      end
      contents_arr.shift
      contents_arr.each do |content|
        content = create_content(category[:name])
        content.save
        if content.errors.present?
          return  {success: false, error: "Some error occured in Content -> #{content[:name]} in row #{content[:sn] } #{content.errors.full_messages}"}
        else
          #sub category model part
          category_new = create_category(category[:category_name]) if category[:category_name].present?
          parent = create_sub_category(category[:parent_name], nil, nil) if category[:parent_name].present?
          sub_category = create_sub_category(category[:name], category_new, parent)
          if sub_category.errors.present?
            return  {success: false, error: "Some error occured in Sub Category -> #{category[:name]} in row #{category[:sn] } #{category.errors.full_messages}"}
          end
        end
      end
      return {success: true}
    end

    def headers
      {
        sn: 'sn',
        name: 'name',
        category_name: 'category_name',
        sub_category_name: 'sub_category_name',
        tags: 'tags',
        searchable_text: 'searchable_text',
        publish_date: 'publish_date',
        status: 'status',
        language: 'language',
        language_code: 'language_code',
        is_content_language: "is_content_language",
        is_app_language: "is_app_language",
        content_type_name: "content_type_name",
        author_name: "new_author",
      }
    end
  end
end
