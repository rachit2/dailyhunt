FactoryBot.define do
  factory :category, class: BxBlockCategories::Category do
    name { Faker::Alphanumeric.unique.alphanumeric(7) }
    dark_icon { Rails.root.join("#{Rails.root}/app/assets/images/govt_job/dark.png").open }
    dark_icon_active { Rails.root.join("#{Rails.root}/app/assets/images/govt_job/dark_active.png").open }
    dark_icon_inactive { Rails.root.join("#{Rails.root}/app/assets/images/govt_job/dark_inactive.png").open }
    light_icon { Rails.root.join("#{Rails.root}/app/assets/images/govt_job/light.png").open }
    light_icon_active { Rails.root.join("#{Rails.root}/app/assets/images/govt_job/light_active.png").open }
    light_icon_inactive { Rails.root.join("#{Rails.root}/app/assets/images/govt_job/light_inactive.png").open }
  end
end
