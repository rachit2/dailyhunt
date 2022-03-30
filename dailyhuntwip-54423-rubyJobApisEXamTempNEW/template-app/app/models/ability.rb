class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :dashboard
    can :access, :rails_admin
    if user && user.super_admin?
      can :manage, :all
      cannot :destroy, BxBlockContentmanagement::Author
    end

    if user.partner?
      filter_contents = BxBlockContentmanagement::Content.partner_content(user.id).ids
      can :manage, BxBlockContentmanagement::Content, id: (filter_contents << nil)
      can :read, BxBlockCategories::Category, id: user.partner.categories
      can :read, BxBlockCategories::SubCategory, id: user.partner.sub_categories
      can :read, BxBlockLanguageoptions::Language
      can :read, BxBlockContentmanagement::ContentType, id: user.partner.content_types
      can :read, BxBlockContentmanagement::AudioPodcast
      can :read, BxBlockContentmanagement::ContentText
      can :read, BxBlockContentmanagement::ContentVideo
      can :read, BxBlockContentmanagement::LiveStream
      can :read, BxBlockContentmanagement::Author
      can :manage, BxBlockContentmanagement::Quiz
      can :manage, BxBlockJobs::Job
      can :manage, BxBlockContentmanagement::Exam
      can :manage, BxBlockExperts::CareerExpert
      can :manage, BxBlockContentmanagement::TestQuestion
      can :manage, BxBlockContentmanagement::Option
    end

    if user.operations_l2?
      can :manage, BxBlockCategories::Category
      can :manage, BxBlockCategories::SubCategory

      operation_l2 = BxBlockAdmin::AdminUser.operation_l2_user.pluck(:id)
      can :manage, BxBlockAdmin::AdminUser, id: (operation_l2 << nil)
      can :manage, BxBlockRolesPermissions::Role, id: BxBlockRolesPermissions::Role.operation_l2_role
      can :manage, BxBlockAdmin::AdminUserRole
      can :read, BxBlockContentmanagement::Author
      can :manage, BxBlockContentmanagement::Content
      can :read, BxBlockLanguageoptions::Language
      can :manage, BxBlockContentmanagement::ContentType
      can :read, BxBlockContentmanagement::AudioPodcast
      can :read, BxBlockContentmanagement::ContentText
      can :read, BxBlockContentmanagement::ContentVideo
      can :read, BxBlockContentmanagement::LiveStream
    end

    if user.operations_l1?
      contents_id = BxBlockContentmanagement::Content.operations_l1_content.pluck(:id)
      contents_id_sub = BxBlockContentmanagement::Content.submit_for_review_l1_content.pluck(:id)

      can :manage, BxBlockContentmanagement::ContentType
      can :manage, BxBlockContentmanagement::Content, id: (contents_id << nil)
      cannot [:edit_content, :destroy], BxBlockContentmanagement::Content, id: (contents_id_sub << nil)

      operation_l1 = BxBlockAdmin::AdminUser.partner_user.pluck(:id)

      can :manage, BxBlockAdmin::AdminUser, id: (operation_l1 << nil)
      can :manage, BxBlockRolesPermissions::Role, id: BxBlockRolesPermissions::Role.operation_l1_role
      can :manage, BxBlockAdmin::AdminUserRole
      can :read, BxBlockCategories::Category
      can :read, BxBlockCategories::SubCategory
      can :read, BxBlockLanguageoptions::Language
      can :read, BxBlockContentmanagement::ContentType
      can :read, BxBlockContentmanagement::AudioPodcast
      can :read, BxBlockContentmanagement::ContentText
      can :read, BxBlockContentmanagement::ContentVideo
      can :read, BxBlockContentmanagement::LiveStream
      can :read, BxBlockContentmanagement::Author
    end

    if user.content?
      blogs_content = BxBlockContentmanagement::Content.blogs_content.pluck(:id)
      can :manage, BxBlockContentmanagement::Content, id: (blogs_content << nil)
      blogs_content_type = BxBlockContentmanagement::ContentType.blog.pluck(:id)
      can :read, BxBlockContentmanagement::ContentType, id: (blogs_content_type)
      can :read, BxBlockCategories::Category
      can :read, BxBlockCategories::SubCategory
      can :read, BxBlockLanguageoptions::Language
      can :read, BxBlockContentmanagement::ContentText
      can :read, BxBlockContentmanagement::Author
    end


    if user.sales_and_marketing?
      can :read, AccountBlock::Account
    end

    cannot :destroy, BxBlockRolesPermissions::Partner
    cannot :edit, BxBlockRolesPermissions::Partner
    cannot :create, BxBlockRolesPermissions::Partner

    cannot :destroy, AccountBlock::Account
    cannot :edit, AccountBlock::Account
    cannot :create, AccountBlock::Account
  end
end
