require 'sidekiq/web'
Rails.application.routes.draw do
  authenticate :admin_users do
    mount Sidekiq::Web => '/sidekiq'
  end
  root to: "rails_admin/main#dashboard"
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin', class_name: 'BxBlockAdmin::AdminUser'
  devise_for :admin_users, controllers: { sessions: 'admin_users/sessions' }, class_name: 'BxBlockAdmin::AdminUser'

  get "/healthcheck", to: proc { [200, {}, ["Ok"]] }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :bx_block_login do
    resources :social_login, only: %i[create] do
      collection do
        post :apple_login_callback
      end
    end
    resources :application_configs do
      collection do
        get 'background_file'
      end
    end
  end

  namespace :bx_block_experts do
    resources :career_experts do
      collection do
        get :show_follow_contents
        delete 'unfollow_content/:content_id', to: 'career_experts#unfollow_content'
        get 'show_follow_content/:content_id', to:'career_experts#show_follow_content'
        get 'get_videos'
        get 'get_blogs'
        get 'get_articles'
      end
      member do
        post 'follow_content/:content_id', to: 'career_experts#follow_content'
        post :book_or_follow
        get 'videos/:content_video_id', to: 'career_experts#get_video'
        get 'text/:content_text_id', to: 'career_experts#get_text'
      end
    end
    resources :articles
    resources :account_experts
  end

  namespace :bx_block_profile do
    resources :profiles, only: %i[show update] do
      collection do
        get :caste_category
        delete :delete_profile_categories_data
      end
    end
    resources :boards, only: %i[index]
    resources :degrees, only: %i[index]
    resources :standards, only: %i[index]
    resources :subjects, only: %i[index]
    resources :colleges, only: %i[index] do
      collection do
        get :sub_categories
        get :college_school_search
        get :specializations
      end
    end
    resources :educational_courses, only: %i[index]
    resources :education_levels, only: %i[index]
    resources :specializations, only: %i[index]
    resources :domain_work_functions, only: %i[index]
    resources :locations, only: %i[create show index]
    resources :universities, only: %i[create show index]
    resources :schools, only: %i[create show index] do
      collection do
        get :total_fees_list
      end
    end
  end

  namespace :bx_block_dashboard do
    resources :faqs, only: %i[show index]
    resources :help_and_supports, only: %i[show index]
  end

  namespace :bx_block_categories do
    resources :categories, only: %i[show index update]
    resources :sub_categories, only: %i[show index update]
    resources :cta, only: %i[index]
  end

  namespace :bx_block_languageoptions do
    resources :languages, only: %i[index update] do
      collection do
        post 'set_app_language'
        get 'get_all_translations'
        get 'last_translation_time'
      end
    end
  end


  namespace :bx_block_companies do
    resources :companies do
      member do
        get 'jobs/:job_id', to: 'companies#jobs'
      end
    end
  end

  namespace  :bx_block_contentmanagement do
    resources :contents, only: %i[show index] do
      collection do
        get :get_content_detail
        post :reindex_contents
        get :run_seeds
        get :bannerable
        get :recommended_videos
        get :recommend_audio_podcasts
        get :get_content_provider
      end
    end

    resources :audio_podcasts, only: %i[show index] do
      collection do
        get :home_audio_podcasts
      end
    end

    resources :banners, only: %i[index]

    resources :mock_tests

    resources :quizzes do
      collection do
        get :home_quizzes
        get :myquizzes
        get :explore
      end
      member do
        post :create_question
        post :update_question
      end
    end
    resources :user_quizzes do
      collection do
        post :user_option
        post :update_option
        get :my_score
      end
      member do
        get :option
      end
    end
    resources :authors, only: %i[show index]
    resources :follows, only: %i[create destroy index] do
      collection do
        get :followers_content
        post :unfollow
      end
    end
    resources :blogs, only: %i[index]
    resources :news_articles, only: %i[index]
    resources :bookmarks, only: %i[create destroy index] do
      collection do
        post :unfollow
      end
    end
    resources :content_types, only: %i[index]
    resources :tags, only: %i[index]
    resources :content_providers, only: %i[index]
    resources :exams, only: %i[create update show index] do
      member do

        post :create_mock_test
        get 'videos/:content_video_id', to: 'exams#get_video'
        get :mock_tests
        get 'mock_tests/:mock_test_id', to: 'exams#mock_test'
        get :all_assessments
        get 'assessments/:assessment_id', to: 'exams#assessment'
        get :download_papers
      end
    end
    resources :courses, only: %i[index create update show] do
        collection do
        post :order_courses
        get :home_courses
        post :free_trail
        get :free_trails
        get :shotlist_courses
        get :recommended_courses
      end
      member do
        post :ratings
        get :bought_courses
      end
    end
    resources :course_carts, only: %i[index create]
    resources :course_orders, only: %i[index create] do
      collection do
        get :my_courses
      end
    end
    resources :lession_contents do
      collection do
        post :read_lession_contents
      end
    end
    resources :assessments do
      collection do
        get :assessments
        post :assessment_question
        get :my_assessments
        get :assessment_answers
      end

      member do
        post :create_question
        put :update_question
      end
    end
    resources :user_assessments do
      collection do
        post :user_option
        post :update_option
        get :my_score
      end
    end
    resources :epubs, only: %i[index show] do
      collection do
        get :home_epubs
      end
    end
  end

  namespace :bx_block_roles_permissions do
    resources :partners, only: %i[new create] do
      collection do
        get :terms_and_condition
      end
    end
  end

  namespace :bx_block_payments do
    resources :payments, only: %i[create]
  end

  namespace :account_block do
    namespace :accounts do
      resources :email_confirmations, only: %i(create)
    end
  end

  namespace :bx_block_communityforum do
    resources :questions, only: %i[show create index destroy update] do
      collection do
        get :my_questions
        get :drafted_questions
        get :published_questions
        get :details
        get :feed_questions
      end
    end
    resources :answers, only: %i[show create index]
    resources :comments, only: %i[show create index]
    resources :likes, only: %i[show create index destroy] do
      collection do
        post :update_like
        post :delete_like
      end
    end
    resources :votes, only: %i[create]
  end

  namespace :bx_block_jobs do
    # resources :job_positions, only: %i[show index]
    resources :job_categories, only: %i[show index]
    resources :jobs, only: %i[show index] do
      collection do
        get :job_categories
        get :my_jobs
        get :locations
        get :job_type_and_experience
      end
      member do
        post :apply_job
      end
    end
  end

  post 'bx_block_contentmanagement/webhooks/contents', to: 'bx_block_contentmanagement/contents#contents'
  put 'bx_block_contentmanagement/webhooks/update_contents/:id', to: 'bx_block_contentmanagement/contents#update_contents'

  post '/partner_login', to: 'bx_block_login/logins#partner_login'

  mount BxBlockForgotPassword::Engine => '/bx_block_forgot_password', as: 'forgot_password'

  get 'bx_block_filter_items/content_management/filters', to: 'bx_block_filter_items/filtering#content_page_filters'

end
