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
require 'rails_helper'

RSpec.describe BxBlockCategories::Cta, type: :model do
  describe 'associations' do
    it { should belong_to(:category).class_name('BxBlockCategories::Category') }
  end

  describe 'validations' do
    it { should define_enum_for(:text_alignment).with_values(["centre", "left", "right"]) }
    it { should define_enum_for(:button_alignment).with_values(["centre", "left", "right"]) }

      
    context "should return response of validate presence of author and publish date" do
    let(:cta) { FactoryBot.create(:cta)}

      it 'should validate presence of headline' do
        cta.headline = nil
        expect(cta.save).to eq(false)
        expect(cta.errors[:headline]).to eq(["can't be blank"])
      end

      it 'should validate presence of text_alignment' do
        cta.text_alignment = nil
        expect(cta.save).to eq(false)
        expect(cta.errors[:text_alignment]).to eq(["can't be blank"])
      end

      it 'should validate presence of button_text' do
        cta.button_text = nil
        expect(cta.save).to eq(false)
        expect(cta.errors[:button_text]).to eq(["can't be blank"])
      end

      it 'should validate presence of redirect_url' do
        cta.redirect_url = nil
        expect(cta.save).to eq(false)
        expect(cta.errors[:redirect_url]).to eq(["can't be blank"])
      end

      it 'should validate presence of button_alignment' do
        cta.button_alignment = nil
        expect(cta.save).to eq(false)
        expect(cta.errors[:button_alignment]).to eq(["can't be blank"])
      end
    end
  end
end
