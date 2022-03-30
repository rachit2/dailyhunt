module BxBlockBulkUpload
  class XmlIndexContentService
    require 'crack'
    class << self
      CAREER_INDIA_FEEDS = {
        en: "https://rss.oneindia.com/xml4apps/www.careerindia.com/latest.xml",
        hi: "https://rss.oneindia.com/xml4apps/hindi.careerindia.com/latest.xml",
        ta: "https://rss.oneindia.com/xml4apps/tamil.careerindia.com/latest.xml",
        kn: "https://rss.oneindia.com/xml4apps/kannada.careerindia.com/latest.xml"
      }

      def create_content
        CAREER_INDIA_FEEDS.each do |language|
          begin
            doc = Nokogiri::XML(open(language[1]))
          rescue Exception => e
            Rails.logger.error(e)
            errors = e
          end
          if errors.present?
            return { success: false, errors: "Unable to open the link. " }
          else
            json_response = JSON[Hash.from_xml(doc.to_xml).to_json]
            json_response["Data"]["Item"].each do |response|
              BxBlockBulkUpload::XmlCreateContentService.create_content(create_content_params(response, "en"), response, "create")
            end
          end
        end
        return { success: true }
      end

      private

      def find_category(category_id)
        BxBlockCategories::Category.find_by(id: category_id)
      end

      def create_content_params(json_response, language_code)
        category_id = get_category(json_response["CategoryName"])
        sub_category_id = get_sub_category(find_category(category_id), json_response["CategoryName"])
        content_type_id = get_content_type("News Articles", "Text")
        {
          crm_id: json_response["Guid"],
          crm_type: "careerindia",
          category_id: category_id,
          sub_category_id: sub_category_id,
          language_id: get_language(language_code),
          content_type_id: content_type_id,
          status: "publish",
          tag_list: json_response["Tags"],
          detail_url: json_response["Link"],
          admin_user_id: get_admin_user_id(category_id, sub_category_id, content_type_id)
        }
      end

      def get_sub_category(category_id, category_name)
        sub_category_exist = BxBlockCategories::SubCategory.find_by('lower(name) = ?', strip_downcase(category_name))
        if sub_category_exist.blank?
          sub_category_exist = BxBlockCategories::SubCategory.new(name: category_name, categories: [category_id])
          sub_category_exist.save
        end
        sub_category_exist.id
      end

      def get_category(category_name)
        dark = Rails.root.join("#{Rails.root}/app/assets/images/default_category/dark.png").open
        dark_active = Rails.root.join("#{Rails.root}/app/assets/images/default_category/dark_active.png").open
        dark_inactive = Rails.root.join("#{Rails.root}/app/assets/images/default_category/dark_inactive.png").open
        light = Rails.root.join("#{Rails.root}/app/assets/images/default_category/light.png").open
        light_active = Rails.root.join("#{Rails.root}/app/assets/images/default_category/light_active.png").open
        light_inactive = Rails.root.join("#{Rails.root}/app/assets/images/default_category/light_inactive.png").open
        category = BxBlockCategories::Category.where('lower(name) = ?', category_name.downcase).first_or_create(:name=>category_name)
        category.update(dark_icon: dark, dark_icon_active: dark_active, dark_icon_inactive: dark_inactive, light_icon: light, light_icon_active: light_active, light_icon_inactive: light_inactive)
        category.id
      end

      def get_language(language_code)
        language = BxBlockLanguageoptions::Language.find_by('lower(language_code) = ?', strip_downcase(language_code))
        if language.blank?
          language = BxBlockLanguageoptions::Language.new(name: language_name(language_code), language_code: language_code)
          language.save
        end
        language.id
      end

      def language_name(language_code)
        language = {
          "en"=> "English",
          "hi"=> "Hindi",
          "ta"=> "Tamil",
          "kn" => "Kannada"
        }
        language[language_code]
      end

      def get_content_type(content_val, type)
        content_type = BxBlockContentmanagement::ContentType.find_by('lower(name) = ?', content_val.downcase)
        if content_type.blank?
          content_type = BxBlockContentmanagement::ContentType.new(name: content_val, type: type)
          content_type.save
        end
        content_type.id
      end

      def get_admin_user_id(category_id, sub_category_id, content_type_id, admin_user=nil)
        admin_user = get_admin_user(admin_user)
        if admin_user.nil?
          params = get_params(category_id, sub_category_id, content_type_id)
          partner_role = BxBlockRolesPermissions::Role.find_by(name: "partner")
          admin_attributes = params.merge!(role: partner_role)
          admin_attributes["partner_attributes"] = admin_attributes["partner_attributes"].merge(created_by_admin: false)
          admin_user = BxBlockAdmin::AdminUser.new(admin_attributes)
          admin_user.set_random_password
          admin_user.save
        end
        admin_user.id
      end

      def get_params(category_id, sub_category_id, content_type_id)
        {
          "email" => "partner@careerindia.com",
          "partner_attributes"=> {
            "name" => "careerindia",
            "status" => "approved",
            "spoc_name" => "CareerHunt India(SPOC name)",
            "spoc_contact" => "09416226394",
            "address" => "Office No. SOHO-302, Block - B, 3rd Floor, Chandigarh Citi Centre, VIP Rd, Zirakpur",
            "category_ids" => [category_id],
            "sub_category_ids" => [sub_category_id],
            "content_type_ids" => [content_type_id]
          }
        }
      end

      def get_admin_user(email)
        if email.nil?
          BxBlockAdmin::AdminUser.find_by('lower(email) = ?', "partner@careerindia.com")
        else
          BxBlockAdmin::AdminUser.find_by('lower(email) = ?', email)
        end
      end

      def strip(str)
        str.to_s.strip
      end

      def strip_downcase(str)
        strip(str).downcase
      end
    end
  end
end
