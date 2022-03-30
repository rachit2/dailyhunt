# == Schema Information
#
# Table name: partners
#
#  id                  :bigint           not null, primary key
#  account_name        :string
#  account_number      :bigint
#  address             :text
#  bank_ifsc           :string
#  bank_name           :string
#  created_by_admin    :boolean          default(TRUE)
#  includes_gst        :boolean
#  name                :string
#  partner_margins_per :float
#  partner_type        :integer
#  partnership_type    :integer
#  spoc_contact        :string
#  spoc_name           :string
#  status              :integer
#  tax_margins         :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  admin_user_id       :bigint
#
# Indexes
#
#  index_partners_on_admin_user_id  (admin_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (admin_user_id => admin_users.id)
#
require 'rails_helper'

RSpec.describe BxBlockRolesPermissions::Partner, type: :model do
  describe 'associations' do
    it { should belong_to(:admin_user).class_name('BxBlockAdmin::AdminUser') }
    it { should have_and_belong_to_many(:categories).class_name('BxBlockCategories::Category').dependent(:destroy) }
    it { should have_and_belong_to_many(:sub_categories).class_name('BxBlockCategories::SubCategory').dependent(:destroy) }
    it { should have_and_belong_to_many(:content_types).class_name('BxBlockContentmanagement::ContentType').dependent(:destroy) }
    it { should define_enum_for(:status).with_values(["pending", "approved", "decline"]) }
    it { should define_enum_for(:partner_type).with_values(["free", "paid"]) }
    it { should define_enum_for(:partnership_type).with_values(["strategic", "general"]) }
    it { should have_one(:signed_agreement).class_name('Pdf').dependent(:destroy) }
    it{ should accept_nested_attributes_for(:signed_agreement).allow_destroy(true) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:spoc_name) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:spoc_contact) }
    it { should validate_numericality_of(:spoc_contact).with_message("Please enter a valid phone number") }
    it { should validate_presence_of(:categories) }
    it { should validate_presence_of(:sub_categories) }
    it { should validate_presence_of(:content_types) }

    context 'when record is created_by_admin' do
      before(:each) do
        allow(subject).to receive(:created_by_admin?).and_return(true)
      end
      it { should validate_presence_of(:partner_type) }
      it { should validate_presence_of(:partnership_type) }
      it { should validate_presence_of(:partner_margins_per) }
      it { should validate_presence_of(:tax_margins) }
    end

    context 'when record is not created_by_admin' do
      before(:each) do
        allow(subject).to receive(:created_by_admin?).and_return(false)
      end
      it { should_not validate_presence_of(:partner_type) }
      it { should_not validate_presence_of(:partnership_type) }
      it { should_not validate_presence_of(:partner_margins_per) }
      it { should_not validate_presence_of(:tax_margins) }
    end
  end

  describe 'Set Defaults' do
    it "change status on initialize for status approved" do
      partner = BxBlockRolesPermissions::Partner.new
      expect(partner.status).to eql("approved")
    end

    it "change status on initialize for status pending" do
      partner = BxBlockRolesPermissions::Partner.new(created_by_admin: false)
      expect(partner.status).to eql("pending")
    end
  end

  describe 'email notification' do
    let(:role){FactoryBot.create(:role, name:"partner")}
    let(:mail) { double(:mail) }

    before(:each) do
      stub_env('APPURL', 'http://localhost')
    end

    context 'when partner signed up' do
      let!(:user){ FactoryBot.create(:admin_user, email:"admin@careerhunt.com", role:role, partner: partner) }
      let(:partner){ FactoryBot.build(:partner, created_by_admin: false, status: :pending) }

      context 'when partner is approved' do
        after(:each) do
          expect{user.reload}.not_to raise_error
          expect{partner.reload}.not_to raise_error
        end

        it 'should send email to user' do
          expect { partner.approved! }.to have_enqueued_job.on_queue('mailers').with(
            'BxBlockRolesPermissions::PartnerMailer', 'welcome_email', 'deliver_now', {args: [user.id, partner.name]}
          )
        end

        it 'should call correct mailer' do
          expect(BxBlockRolesPermissions::PartnerMailer).to receive(:welcome_email).with(user.id, partner.name).and_return(mail)
          expect(mail).to receive(:deliver_later)

          partner.approved!
        end

        it 'should perform email delivery correctly for welcome mail' do
          expect {
            BxBlockRolesPermissions::PartnerMailer.welcome_email(user.id, partner.name).deliver_now
          }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end

      context 'when partner is declined' do
        after(:each) do
          expect{user.reload}.to raise_error(ActiveRecord::RecordNotFound)
          expect{partner.reload}.to raise_error(ActiveRecord::RecordNotFound)
        end

        it 'should send email to user' do
          expect { partner.decline! }.to have_enqueued_job.on_queue('mailers').with(
            'BxBlockRolesPermissions::PartnerMailer', 'decline_email', 'deliver_now', {args: [user.email]}
          )
        end

        it 'should call correct mailer' do
          expect(BxBlockRolesPermissions::PartnerMailer).to receive(:decline_email).with(user.email).and_return(mail)
          expect(mail).to receive(:deliver_later)

          partner.decline!
        end

        it 'should perform email delivery correctly for decline mail' do
          expect {
            BxBlockRolesPermissions::PartnerMailer.decline_email(user.email).deliver_now
          }.to change { ActionMailer::Base.deliveries.count }.by(1)

          partner.decline!
        end
      end
    end

    context 'when partner is created by admin user' do
      let(:user){ FactoryBot.build(:admin_user, email:"admin@careerhunt.com", role:role, partner: partner) }

      context 'when partner is approved' do
        let(:partner){ FactoryBot.build(:partner, created_by_admin: true, status: :approved) }

        after(:each) do
          expect{user.reload}.not_to raise_error
          expect{partner.reload}.not_to raise_error
        end

        it 'should send email to user' do
          expect { user.save! }.to have_enqueued_job.on_queue('mailers').with(
            'BxBlockRolesPermissions::PartnerMailer', 'welcome_email', 'deliver_now', {args: [an_instance_of(Integer), partner.name]}
          )
        end

        it 'should call correct mailer' do
          expect(BxBlockRolesPermissions::PartnerMailer).to receive(:welcome_email).with(an_instance_of(Integer), partner.name).and_return(mail)
          expect(mail).to receive(:deliver_later)

          user.save!
        end

        it 'should perform email delivery correctly for welcome mail' do
          user.save!
          expect {
            BxBlockRolesPermissions::PartnerMailer.welcome_email(user.id, partner.name).deliver_now
          }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end

      context 'when partner is declined' do
        let(:partner){ FactoryBot.build(:partner, created_by_admin: true, status: :decline) }

        it 'should not save the obejct and assign proper error' do
          expect(user.save).to eq(false)
          expect(user.errors["partner.status"]).to eq(["can not be declined while creating"])
        end
      end
    end
  end
end
