module BxBlockCategories
  class BuildCategories
    class << self
      def call(categories_and_sub_categories = categories_and_sub_category_hash)
        categories_and_sub_categories.each do |key,value|
          dark = Rails.root.join("#{Rails.root}/app/assets/images/#{key.downcase.tr(' ', "_")}/dark.png").open
          dark_active = Rails.root.join("#{Rails.root}/app/assets/images/#{key.downcase.tr(' ', "_")}/dark_active.png").open
          dark_inactive = Rails.root.join("#{Rails.root}/app/assets/images/#{key.downcase.tr(' ', "_")}/dark_inactive.png").open
          light = Rails.root.join("#{Rails.root}/app/assets/images/#{key.downcase.tr(' ', "_")}/light.png").open
          light_active = Rails.root.join("#{Rails.root}/app/assets/images/#{key.downcase.tr(' ', "_")}/light_active.png").open
          light_inactive = Rails.root.join("#{Rails.root}/app/assets/images/#{key.downcase.tr(' ', "_")}/light_inactive.png").open
          category = BxBlockCategories::Category.where('lower(name) = ?', key.downcase).first_or_create(:name=>key, :identifier=>category_identifier_hash[key])
          category.update(identifier: category_identifier_hash[key], dark_icon: dark, dark_icon_active: dark_active, dark_icon_inactive: dark_inactive, light_icon: light, light_icon_active: light_active, light_icon_inactive: light_inactive)
          value.each do |val|
            category.sub_categories.where('lower(name) = ?', val.downcase).first_or_create(:name=>val, categories: [category])
          end
        end
      end

      private

      def categories_and_sub_category_hash
        {
          "K12" => [
            "Pre Primary (kg)",
            "Primary (1 to 5)",
            "Middle (6 to 8)",
            "Secondary (9 & 10)",
            "Senior Secondary (11 & 12)"
          ],
          "Higher Education" => [
            "Accounting & Commerce",
            "Animation",
            "Architecture & Alanning",
            "Arts (Fine/Visual/Performing)",
            "Aviation",
            "Banking, Finance & Insurance",
            "Beauty & Fitness",
            "Business & Management Studies",
            "Design",
            "Engineering",
            "Hospitality & Travel",
            "Humanities & Social Sciences",
            "IT & Software",
            "Law",
            "Mass Communication & Media",
            "Medicine & Health Sciences",
            "Nursing",
            "Science",
            "Teaching & Education",
          ],
          "Govt Job" => [
            "Banking",
            "Railways",
            "Defense",
            "Police",
            "UGC NET",
            "Teaching",
            "SSC",
            "UPSC",
            "State PSCs",
            "Judiciary"
          ],
          "Competitive Exams" => [
            "JEE",
            "NEET",
            "CLAT"
          ],
          "Upskilling" => []
        }
      end

      def category_identifier_hash
        {
          "K12" => "k12",
          "Higher Education" => "higher_education",
          "Govt Job" => "govt_job",
          "Competitive Exams" => "competitive_exams",
          "Upskilling" => "upskilling"
        }
      end

    end
  end
end