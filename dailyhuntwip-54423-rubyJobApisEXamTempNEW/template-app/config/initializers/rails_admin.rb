# frozen_string_literal: true

require Rails.root.join('lib', 'CreateContent.rb')
require Rails.root.join('lib', 'BuildContent.rb')
require Rails.root.join('lib', 'EditContent.rb')
require Rails.root.join('lib', 'ImportExcel.rb')
require Rails.root.join('lib', 'ExportTranslationExcel.rb')
require Rails.root.join('lib', 'SendExcel.rb')
require Rails.root.join('lib', 'CreateAuthor.rb')
require Rails.root.join('lib', 'ImportData.rb')
require Rails.root.join('lib', 'BulkUpload.rb')
require Rails.root.join('lib', 'DownloadTemplate.rb')

RailsAdmin.config do |config|
  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :admin_user
  # end
  # config.current_user_method(&:current_admin_user)

  ## == CancanCan ==
  config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  module RailsAdmin
    module Config
      module Actions
        class CreateContent < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
        end

        class BuildContent < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
        end

        class EditContent < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
        end

        class ImportExcel < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
        end

        class ExportTranslationExcel < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
        end

        class SendExcel < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
        end

        class CreateAuthor < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
        end

        class ImportData < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
        end

        class BulkUpload < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
        end

        class DownloadTemplate < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
        end
      end
    end
  end

  config.main_app_name = ['Admin Console', '']

  config.authenticate_with do
    warden.authenticate! scope: :admin_user
  end

  config.current_user_method(&:current_admin_user)

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new do
      except [
        'AccountBlock::Account',
        'BxBlockProfile::Profile',
        'BxBlockContentmanagement::Content',
        'BxBlockContentmanagement::LiveStream',
        'BxBlockContentmanagement::AudioPodcast',
        'BxBlockContentmanagement::ContentText',
        'BxBlockContentmanagement::ContentVideo',
        'BxBlockContentmanagement::Test',
        'BxBlockContentmanagement::Epub'
      ]
    end

    export do
      except ['BxBlockLanguageoptions::ApplicationMessage']
    end
    bulk_delete

    show
    edit do
      except [
        'AccountBlock::Account',
        'BxBlockProfile::Profile',
        'BxBlockContentmanagement::Content',
        'BxBlockContentmanagement::LiveStream',
        'BxBlockContentmanagement::AudioPodcast',
        'BxBlockContentmanagement::ContentText',
        'BxBlockContentmanagement::ContentVideo',
        'BxBlockContentmanagement::Test',
        'BxBlockContentmanagement::Epub'
      ]
    end
    delete do
      except [
        'AccountBlock::Account',
        'BxBlockProfile::Profile',
        'BxBlockContentmanagement::LiveStream',
        'BxBlockContentmanagement::AudioPodcast',
        'BxBlockContentmanagement::ContentText',
        'BxBlockContentmanagement::ContentVideo',
        'BxBlockContentmanagement::Test',
        'BxBlockContentmanagement::Epub'
      ]
    end
    import_excel
    export_translation_excel
    send_excel

    create_content
    build_content
    edit_content
    create_author
    import_data
    bulk_upload
    download_template
    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
  config.included_models = [
    'BxBlockCompany::Company',
    'BxBlockCompany::CompanyAddress',
    'BxBlockLanguageoptions::ApplicationMessage',
    'BxBlockLanguageoptions::ApplicationMessage::Translation',
    'BxBlockCategories::Category',
    'AccountBlock::Account',
    'BxBlockAdmin::AdminUser',
    'BxBlockCategories::SubCategory',
    'BxBlockLanguageoptions::Language',
    'BxBlockContentmanagement::Content',
    'BxBlockContentmanagement::Course',
    'BxBlockContentmanagement::Lession',
    'BxBlockContentmanagement::Instructor',
    'BxBlockContentmanagement::ContentType',
    'BxBlockContentmanagement::LessionContent',
    'BxBlockContentmanagement::LiveStream',
    'BxBlockContentmanagement::AudioPodcast',
    'BxBlockContentmanagement::ContentText',
    'BxBlockExperts::CareerExpert',
    'BxBlockContentmanagement::ContentVideo',
    'BxBlockContentmanagement::Exam',
    'BxBlockContentmanagement::ExamUpdate',
    'BxBlockContentmanagement::ExamSection',
    'BxBlockContentmanagement::OrderCourse',
    'BxBlockContentmanagement::CourseOrder',
    'BxBlockCategories::Cta',
    'BxBlockContentmanagement::Epub',
    'BxBlockContentmanagement::Author',
    'BxBlockRolesPermissions::Partner',
    'Image',
    'BxBlockVideos::Video',
    'BxBlockLogin::ApplicationConfig',
    'BxBlockProfile::Board',
    'BxBlockProfile::Subject',
    'BxBlockProfile::Class',
    'BxBlockProfile::Degree',
    'BxBlockProfile::specialization',
    'BxBlockProfile::Standard',
    'BxBlockProfile::College',
    'BxBlockProfile::Specialization',
    'BxBlockProfile::Certification',
    'BxBlockProfile::EmploymentDetail',
    'BxBlockProfile::EducationLevel',
    'BxBlockProfile::Profile',
    'BxBlockProfile::EducationalCourse',
    'BxBlockProfile::DomainWorkFunction',
    'BxBlockProfile::TotalFee',
    'BxBlockContentmanagement::Quiz',
    'BxBlockContentmanagement::Assessment',
    'BxBlockContentmanagement::TestQuestion',
    'BxBlockContentmanagement::Option',
    'BxBlockJobs::Job',
    "BxBlockContentmanagement::MockTest",
    'BxBlockContentmanagement::Banner',
    'BxBlockDashboard::Faq',
    'BxBlockDashboard::HelpAndSupport',
    'BxBlockProfile::Location',
    'BxBlockJobs::CompanyJobPosition',
    'BxBlockJobs::JobCategory',
    'BxBlockJobs::JobLocation',
    'BxBlockJobs::JobPlace',
    'BxBlockProfile::City',
    'BxBlockProfile::University',
    'BxBlockProfile::School',
    'BxBlockCommunityforum::Question',
    'BxBlockCommunityforum::Answer',
    'BxBlockCommunityforum::Vote',
    'BxBlockCommunityforum::Comment'
  ]

  config.model 'AccountBlock::SmsAccount' do
    visible false
  end

  config.model 'Image' do
    visible false
  end

  config.model 'BxBlockVideos::Video' do
    visible false
  end

  config.model 'BxBlockContentmanagement::Epub' do
    visible false
  end

  config.model 'AccountBlock::EmailAccount' do
    visible false
  end

  config.model 'AccountBlock::SocialAccount' do
    visible false
  end

  config.model 'AccountBlock::EmailOtp' do
    visible false
  end

  config.model 'AccountBlock::SmsOtp' do
    visible false
  end

  config.model 'ActiveStorage::Attachment' do
    visible false
  end

  config.model 'ActiveStorage::Blob' do
    visible false
  end

  config.model 'BxBlockCatalogue::Brand' do
    visible false
  end

  config.model 'BxBlockCatalogue::Blob' do
    visible false
  end

  config.model 'BxBlockCatalogue::Catalogue' do
    visible false
  end

  config.model 'BxBlockCatalogue::CatalogueVariant' do
    visible false
  end

  config.model 'BxBlockCatalogue::CatalogueVariantColor' do
    visible false
  end

  config.model 'BxBlockCatalogue::CatalogueVariantSize' do
    visible false
  end

  config.model 'BxBlockCatalogue::CataloguesTag' do
    visible false
  end

  config.model 'BxBlockCatalogue::Review' do
    visible false
  end

  config.model 'BxBlockCatalogue::Tag' do
    visible false
  end

  config.model 'BxBlockDashboard::Dashboard' do
    visible false
  end

  config.model 'ActionMailbox::InboundEmail' do
    visible false
  end

  config.model 'ActionText::RichText' do
    visible false
  end

  config.model 'BxBlockRolesPermissions::Role' do
    visible false
  end

  config.model 'BxBlockRolesPermissions::Partner' do
    visible false
  end

  config.model 'AccountBlock::Account' do
    navigation_label 'Accounts' # Every model with this
    label 'App Users'
  end

  config.model 'BxBlockAdmin::AdminUser' do
    navigation_label 'Accounts'
    label 'Portal Users and Partners'
  end


  ['BxBlockExperts::CareerExpert'].each do |a|
    config.model a do
      navigation_label 'Experts'
    end
  end

  ['BxBlockContentmanagement::ContentType', 'BxBlockContentmanagement::Assessment', 'BxBlockContentmanagement::Banner',
   'BxBlockContentmanagement::CourseOrder', 'BxBlockContentmanagement::Option', 'BxBlockContentmanagement::Quiz', 'BxBlockContentmanagement::TestQuestion', 'BxBlockContentmanagement::OrderCourse', 'BxBlockContentmanagement::Content', 'BxBlockContentmanagement::Exam', 'BxBlockContentmanagement::MockTest', 'BxBlockContentmanagement::Course', 'BxBlockContentmanagement::Instructor', 'BxBlockContentmanagement::Lession', 'BxBlockContentmanagement::LessionContent', 'BxBlockContentmanagement::Banner'].each do |a|
    config.model a do
      navigation_label 'Content Management'
    end
  end

  ['BxBlockDashboard::Faq', 'BxBlockDashboard::HelpAndSupport'].each do |a|
    config.model a do
      navigation_label 'Dashboard'
    end
  end

  config.model 'BxBlockLogin::ApplicationConfig' do
    navigation_label 'Application Configuration'
  end

  ['BxBlockContentmanagement::LiveStream', 'BxBlockContentmanagement::AudioPodcast',
   'BxBlockContentmanagement::ContentText', 'BxBlockContentmanagement::ContentVideo', 'BxBlockContentmanagement::Author'].each do |a|
    config.model a do
      visible false
    end
  end

  ['BxBlockCategories::Category', 'BxBlockCategories::SubCategory', 'BxBlockCategories::Cta'].each do |a|
    config.model a do
      navigation_label 'Categories' # Every model with this
    end
  end

  ['BxBlockLanguageoptions::Language', 'BxBlockLanguageoptions::ApplicationMessage'].each do |a|
    config.model a do
      navigation_label 'Language Options'
    end
  end

  config.model 'BxBlockLanguageoptions::ApplicationMessage' do
    configure :translations, :globalize_tabs
  end

  config.model 'BxBlockJobs::Job' do
    navigation_label 'Jobs'
  end

  config.model 'BxBlockJobs::JobCategory' do
    navigation_label 'Jobs'
  end

  config.model 'BxBlockJobs::CompanyJobPosition' do
    navigation_label 'Jobs'
  end

  config.model 'BxBlockJobs::JobLocation' do
    object_label_method do
      :city
    end
    navigation_label 'Jobs'
  end

  config.model 'BxBlockJobs::JobPlace' do
    navigation_label 'Jobs'
  end

  config.model 'BxBlockJobs::JobType' do
    navigation_label 'Jobs'
  end

  ['BxBlockProfile::Location', 'BxBlockProfile::City'].each do |a|
    config.model a do
      navigation_label 'Location (Province) & Cities'
    end
  end

  config.model 'BxBlockProfile::University' do
    navigation_label 'Universities'
  end

  config.model 'BxBlockProfile::School' do
    navigation_label 'Schools'
  end

  config.model 'BxBlockCommunityforum::Question' do
    label 'Discussion Forum'
  end

  ['BxBlockCommunityforum::Question', 'BxBlockCommunityforum::Answer', 'BxBlockCommunityforum::Vote',
   'BxBlockCommunityforum::Comment'].each do |a|
    config.model a do
      navigation_label 'Community Forum'
    end
  end

  config.model 'BxBlockLanguageoptions::ApplicationMessage::Translation' do
    visible false
    configure :locale, :hidden do
      help ''
    end
    configure :message do
      help ''
    end
  end
end
