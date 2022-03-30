FactoryBot.define do
  factory :partner, class: BxBlockRolesPermissions::Partner do
    name { Faker::Name.unique.name }
    spoc_name { Faker::Name.unique.name }
    spoc_contact { "+91#{Faker::Number.number(10)}" }
    address { Faker::Name.unique.name }
    partner_type { "free" }
    partnership_type { "strategic" }
    partner_margins_per { Faker::Number.number(2) }
    includes_gst { true }
    tax_margins { Faker::Number.number(2) }
    content_types {FactoryBot.create_list(:content_type, 1)}
    sub_categories {FactoryBot.create_list(:sub_category, 1)}
    categories {FactoryBot.create_list(:category, 1)}
  end
end