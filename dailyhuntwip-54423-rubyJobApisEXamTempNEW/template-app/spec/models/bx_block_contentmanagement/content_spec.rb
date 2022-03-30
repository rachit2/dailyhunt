# == Schema Information
#
# Table name: contents
#
#  id               :bigint           not null, primary key
#  archived         :boolean          default(FALSE)
#  contentable_type :string
#  crm_type         :integer
#  detail_url       :string
#  feature_article  :boolean
#  feature_video    :boolean
#  feedback         :string
#  is_popular       :boolean
#  is_trending      :boolean
#  publish_date     :datetime
#  review_status    :integer
#  searchable_text  :string
#  status           :integer
#  view_count       :bigint           default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  admin_user_id    :integer
#  author_id        :bigint
#  category_id      :integer
#  content_type_id  :integer
#  contentable_id   :bigint
#  crm_id           :integer
#  language_id      :integer
#  sub_category_id  :integer
#
# Indexes
#
#  index_contents_on_author_id                            (author_id)
#  index_contents_on_contentable_type_and_contentable_id  (contentable_type,contentable_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => authors.id)
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::Content, type: :model do
  describe 'associations' do
    it { should belong_to(:category).class_name('BxBlockCategories::Category') }
    it { should belong_to(:sub_category).class_name('BxBlockCategories::SubCategory') }
    it { should belong_to(:content_type).class_name('BxBlockContentmanagement::ContentType') }
    it { should belong_to(:language).class_name('BxBlockLanguageoptions::Language') }
    it { should belong_to(:contentable).dependent(:destroy) }
    it { should belong_to(:author).class_name('BxBlockContentmanagement::Author').optional }
    it { should have_many(:bookmarks).class_name('BxBlockContentmanagement::Bookmark').dependent(:destroy) }
    it { should have_many(:account_bookmarks).class_name('AccountBlock::Account').through(:bookmarks) }

    it { should define_enum_for(:status).with_values(["draft", "publish", "disable"]) }
    it{ should accept_nested_attributes_for :contentable }



    context "should return response of validate length of tag  " do

      let!(:audio_podcast) { FactoryBot.create(:audio_podcast)}
      let(:category) { FactoryBot.create(:category)}
      let(:sub_category) { FactoryBot.create(:sub_category)}
      let(:language) { FactoryBot.create(:language, name:"english",language_code:"en")}
      let(:content_type) { FactoryBot.create(:content_type)}
      let(:content) { FactoryBot.create(:content, category_id: category.id, sub_category_id: sub_category.id, content_type_id: content_type.id, language_id: language.id, contentable_attributes: {heading: audio_podcast.heading, description:  audio_podcast.description})}

      it 'should validate length of content tag list which is invalid' do
        tag = "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcssss"
        content.tag_list = tag
        expect(content.save).to eq(false)
        expect(content.errors[:tag]).to eq(["#{tag} must be shorter than 35 characters maximum"])
      end

      it 'should validate length of content tag list which is valid' do
        content.tag_list = "audio"
        expect(content.save).to eq(true)
        expect(content.tag_list[0]).to eq("audio")
      end
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:status) }

    context "should return response of validate presence of author and publish date" do

      let!(:audio_podcast) { FactoryBot.create(:audio_podcast)}
      let!(:author) { FactoryBot.create(:author)}
      let!(:blogs) { FactoryBot.create(:blogs)}
      let(:category) { FactoryBot.create(:category)}
      let(:sub_category) { FactoryBot.create(:sub_category)}
      let(:language) { FactoryBot.create(:language, name:"english",language_code:"en")}
      let(:content_type) { FactoryBot.create(:blog_content_type)}
      let(:content) { FactoryBot.create(:content, category: category, sub_category: sub_category, content_type: content_type, language: language, contentable_attributes: {headline: blogs.headline, content:  blogs.content, hyperlink: blogs.hyperlink, affiliation: blogs.affiliation}, author: author, status: 'draft')}
      let(:content1) { FactoryBot.create(:content, category: category, sub_category: sub_category, content_type: content_type, language: language, contentable_attributes: {headline: blogs.headline, content:  blogs.content, hyperlink: blogs.hyperlink, affiliation: blogs.affiliation}, author: author)}

      it 'should validate presence of publish date when status is publish' do
        content.status = 'publish'
        content.publish_date = nil
        expect(content.save).to eq(false)
        expect(content.errors[:publish_date]).to eq(["can't be blank"])
      end

      it 'should validate presence of author when contentable is blogs' do
        content.author_id = nil
        expect(content.save).to eq(false)
        expect(content.errors[:author_id]).to eq(["can't be blank"])
      end

      it 'should validate status when it changes on update' do
        content1.status = 'draft'
        expect(content1.save).to eq(false)
        expect(content1.errors[:status]).to eq(["can't be change to draft."])
      end

      it "publish date can't be changed" do
        expect(content1.publish?).to eq(true)
        content1.publish_date =  DateTime.current
        expect(content1.save).to eq(false)
        expect(content1.errors[:publish_date]).to eq(["can't be changed after published."])
      end

      it "can change publish date if publish date is not set previously" do
        content1.publish_date = nil
        expect(content1.save(validate: false)).to eq(true)
        expect(content1.publish?).to eq(true)
        expect(content1.publish_date).to be_blank

        content1.publish_date =  DateTime.current
        expect(content1.save).to eq(true)
      end
    end

    context "should return response of validate content type" do
      let!(:audio_podcast) { FactoryBot.create(:audio_podcast)}
      let!(:author) { FactoryBot.create(:author)}
      let!(:blogs) { FactoryBot.create(:blogs)}
      let(:category) { FactoryBot.create(:category)}
      let(:sub_category) { FactoryBot.create(:sub_category)}
      let(:language) { FactoryBot.create(:language, name:"english",language_code:"en")}
      let(:content_type) { FactoryBot.create(:blog_content_type)}
      let(:content) { FactoryBot.create(:content, category_id: category.id, sub_category_id: sub_category.id, content_type_id: content_type.id, language_id: language.id, contentable_attributes: {headline: blogs.headline, content:  blogs.content, hyperlink: blogs.hyperlink, affiliation: blogs.affiliation}, author_id: author.id)}

      it "content type can't be updated" do
        content.content_type_id = 'publish'
        expect(content.save).to eq(false)
        expect(content.errors[:content_type_id]).to eq(["can't be updated"])
      end
    end
  end

  describe 'Set Defaults' do
    it "change status on initialize for status approved" do
      content = BxBlockContentmanagement::Content.new
      expect(content.status).to eql("draft")
    end
  end
end
