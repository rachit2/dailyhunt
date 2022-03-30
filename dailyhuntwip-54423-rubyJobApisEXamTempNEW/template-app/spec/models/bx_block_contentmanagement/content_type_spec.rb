# == Schema Information
#
# Table name: content_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  type       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  identifier :integer
#  rank       :integer
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::ContentType, type: :model do

  describe 'associations' do
    it { should have_many(:contents).class_name('BxBlockContentmanagement::Content').dependent(:destroy) }
    it { should have_and_belong_to_many(:partners).class_name('BxBlockRolesPermissions::Partner').join_table(:content_types_partners).dependent(:destroy) }
    it { should define_enum_for(:type).with_values(["Text", "Videos", "Live Stream", "AudioPodcast", "Test", "Epub"]) }
    it { should define_enum_for(:identifier).with_values(["news_article", "audio_podcast", "blog", "live_streaming", "study_material", "video_short", "video_full"]) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:type) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_uniqueness_of(:identifier).ignoring_case_sensitivity.allow_blank }
  end

  describe 'TYPE_MAPPINGS' do
    EXPECTEDTYPEMAPPINGS = {
      "Text" => BxBlockContentmanagement::ContentText.name,
      "Videos" => BxBlockContentmanagement::ContentVideo.name,
      "Live Stream" => BxBlockContentmanagement::LiveStream.name,
      "AudioPodcast" => BxBlockContentmanagement::AudioPodcast.name,
      "Test" => BxBlockContentmanagement::Test.name,
      "Epub" => BxBlockContentmanagement::Epub.name
    }
    context 'valid type mappings' do
      it "valid type mappings" do
        expect(BxBlockContentmanagement::ContentType::TYPE_MAPPINGS).to eq(EXPECTEDTYPEMAPPINGS)
      end

      it 'check enum type with type mappings' do
        expect(BxBlockContentmanagement::ContentType.types.keys).to eq(BxBlockContentmanagement::ContentType::TYPE_MAPPINGS.keys)
      end
    end
  end

  describe 'Type Class' do
    context 'should return response of type class' do
      let(:content_type) { FactoryBot.create(:content_type)}
      BxBlockContentmanagement::ContentType.types.keys do |type|
        it "return correct class for type #{type}" do
          content_type.update(type: type)
          expect(content_type.type_class).to eq(BxBlockContentmanagement::ContentType::TYPE_MAPPINGS[type])
        end
      end
    end

    context 'should return error for invalid type class' do
      let(:content_type) { FactoryBot.create(:content_type, type: "type")}
      it 'invalid value for type class' do
        expect { content_type }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'inheritance_column' do
    it 'should be blank' do
      expect(described_class.inheritance_column).to be_blank
    end
  end
end
