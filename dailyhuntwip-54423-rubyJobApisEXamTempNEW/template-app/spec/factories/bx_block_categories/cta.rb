# == Schema Information
#
# Table name: cta
#
#  id                      :bigint           not null, primary key
#  button_alignment        :integer
#  button_text             :string
#  description             :text
#  has_button              :boolean
#  headline                :string
#  is_image_cta            :boolean
#  is_long_rectangle_cta   :boolean
#  is_square_cta           :boolean
#  is_text_cta             :boolean
#  long_background_image   :string
#  redirect_url            :string
#  square_background_image :string
#  text_alignment          :integer
#  visible_on_details_page :boolean
#  visible_on_home_page    :boolean
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  category_id             :bigint
#
# Indexes
#
#  index_cta_on_category_id  (category_id)
#
FactoryBot.define do
  factory :cta, class: BxBlockCategories::Cta do
    headline { Faker::Alphanumeric.unique.alphanumeric(7) }
    description { Faker::Alphanumeric.unique.alphanumeric(15) }
    category
    is_square_cta { true }
    is_long_rectangle_cta { true }
    is_text_cta { true }
    is_image_cta { true }
    has_button { true }
    visible_on_details_page { true }
    visible_on_home_page { true }
    text_alignment {"left"}
    button_alignment {"left"}
    button_text {"ok"}
    redirect_url { 'localhost:300/bx_category'}
    long_background_image { Rails.root.join("#{Rails.root}/app/assets/images/govt_job/dark.png").open }
    square_background_image { Rails.root.join("#{Rails.root}/app/assets/images/govt_job/dark_active.png").open }
  end
end
