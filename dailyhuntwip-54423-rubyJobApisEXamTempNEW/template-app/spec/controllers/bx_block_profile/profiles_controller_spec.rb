require 'rails_helper'

RSpec.describe BxBlockProfile::ProfilesController, type: :controller do
  let!(:account) { FactoryBot.create(:account) }
  let!(:account1) { FactoryBot.build(:account) }
  let!(:category) { FactoryBot.create(:category) }
  let!(:sub_category) { FactoryBot.create(:sub_category, categories: [category]) }
  let(:auth_token) { BuilderJsonWebToken::JsonWebToken.encode(account.id) }

  let(:college_name) { "College name" }
  let(:passing_year) { Date.today.year.to_s }
  let(:school_name) { "School name" }
  let(:caste_category) { "general" }
  let(:certification_course_name) { "Certification Course Name" }
  let(:provided_by) { "Provided By" }
  let(:duration) { 4 }
  let(:completion_year) { Date.today.year.to_s }
  let(:last_employer) { "Last Employer" }
  let(:designation) { "Designation" }

  let!(:board) { FactoryBot.create(:board)}
  let!(:standard) { FactoryBot.create(:standard)}
  let!(:subject) { FactoryBot.create(:subject)}
  let!(:degree) { FactoryBot.create(:degree)}
  let!(:specialization) { FactoryBot.create(:specialization)}
  let!(:educational_course) { FactoryBot.create(:educational_course)}
  let!(:location) { FactoryBot.create(:location) }
  let!(:university) { FactoryBot.create(:university, location: location) }
  let!(:college) { FactoryBot.create(:college, university: university, location: location) }
  let!(:education_level) { FactoryBot.create(:education_level)}
  let!(:domain_work_function) { FactoryBot.create(:domain_work_function)}

  before {
    request.headers.merge! ({"token" => auth_token})
  }

  def success_response
    expect(response.status).to eq 200
  end

  describe 'update' do
    let(:call_api) { put :update, params: update_params.merge(id: :id) }

    def correct_response
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(AccountBlock::AccountSerializer.new(account.reload).serializable_hash.as_json)
    end

    context "Profile update" do
      let(:update_params) {{
        data: {
          first_name: account1.first_name,
          new_email: account1.email,
          new_phone_number: account1.full_phone_number,
          city: account1.city,
          dob: account1.dob,
          gender: account1.gender,
          device_id: account1.device_id,
          desktop_device_id: account1.desktop_device_id,
          image_attributes: {image: Rack::Test::UploadedFile.new(Rails.root.join("#{Rails.root}/app/assets/images/govt_job/dark.png"), "mime/type")},
        }
      }}

      it 'should return http status 200' do
        call_api
        expect(success_response)
      end

      it 'should correct response' do
        call_api
        expect(correct_response)
      end
    end

    context "Categories/Subcategories update" do
      let(:update_params) {{
        data: {
          category_ids: [category.id],
          sub_category_ids: [sub_category.id],
        }
      }}

      it 'should return http status 200' do
        call_api
        expect(success_response)
      end

      it 'should correct response' do
        call_api
        expect(correct_response)
      end
    end

    context "K12 update" do
      let(:update_params) {{
        data: {
          profile_attributes: {
            # k12
            board_id: board.id,
            school_name: school_name,
            standard_id: standard.id,
            subject_ids: [subject.id],
          }
        }
      }}

      it 'should return http status 200' do
        call_api
        expect(success_response)
      end

      it 'should correct response' do
        call_api
        expect(correct_response)
      end
    end

    context "Higher Education update" do
      let(:update_params) {{
        data: {
          profile_attributes: {
            # higher_education
            degree_id: degree.id,
            specialization_id: specialization.id,
            educational_course_id: educational_course.id,
            college_id: college.id,
            college_name: college_name,
            passing_year: passing_year,
          }
        }
      }}


      it 'should return http status 200' do
        call_api
        expect(success_response)
      end

      it 'should correct response' do
        call_api
        expect(correct_response)
      end
    end

    context "Competitive Exam update" do
      let(:update_params) {{
        data: {
          profile_attributes: {
            # competitive_exam
            higher_education_level_id: education_level.id,
            competitive_exam_degree_id: degree.id,
            competitive_exam_specialization_id: specialization.id,
            competitive_exam_course_id: educational_course.id,
            competitive_exam_college_id: college.id,
            competitive_exam_college_name: college_name,
            competitive_exam_passing_year: passing_year,
            competitive_exam_board_id: board.id,
            competitive_exam_school_name: school_name,
            competitive_exam_standard_id: standard.id,
            competitive_exam_subject_ids: [subject.id],
          }
        }
      }}


      it 'should return http status 200' do
        call_api
        expect(success_response)
      end

      it 'should correct response' do
        call_api
        expect(correct_response)
      end
    end

    context "Govt Job update" do
      let(:update_params) {{
        data: {
          profile_attributes: {
            # govt_job
            govt_job_attributes: {
              education_level_id: education_level.id,
              specialization_id: specialization.id,
              caste_category: caste_category,
            },
          }
        }
      }}

      it 'should return http status 200' do
        call_api
        expect(success_response)
      end

      it 'should correct response' do
        call_api
        expect(correct_response)
      end
    end

    context "Upskilling update" do
      context "education_level_profiles update" do
        let(:update_params) {{
          data: {
            profile_attributes: {
              # upskilling
              education_level_profiles_attributes: [{
                education_level_id: education_level.id,
                board_id: board.id,
                specialization_id: specialization.id,
                standard_id: standard.id,
                school_name: school_name,
                degree_id: degree.id,
                college_id: college.id,
                college_name: college_name,
                educational_course_id: educational_course.id,
                passing_year: passing_year,
                subject_ids: [subject.id],
              }],
            }
          }
        }}

        it 'should return http status 200' do
          call_api
          expect(success_response)
        end

        it 'should correct response' do
          call_api
          expect(correct_response)
        end
      end

      context "certifications update" do
        let(:update_params) {{
          data: {
            profile_attributes: {
              # upskilling
              certifications_attributes: [{
                certification_course_name: certification_course_name,
                provided_by: provided_by,
                duration: duration,
                completion_year: completion_year,
              }],
            }
          }
        }}

        it 'should return http status 200' do
          call_api
          expect(success_response)
        end

        it 'should correct response' do
          call_api
          expect(correct_response)
        end
      end

      context "employment_details update" do
        let(:update_params) {{
          data: {
            profile_attributes: {
              # upskilling
              employment_details_attributes: [{
                last_employer: last_employer,
                designation: designation,
                domain_work_function_id: domain_work_function.id,
              }]
            }
          }
        }}

        it 'should return http status 200' do
          call_api
          expect(success_response)
        end

        it 'should correct response' do
          call_api
          expect(correct_response)
        end
      end
    end
  end

  describe "delete_profile_categories_data" do
    before(:each) do
      BxBlockCategories::BuildCategories.call
      expect(BxBlockCategories::Category.all.pluck(:identifier).compact).to match_array(BxBlockCategories::Category.identifiers.keys)
      account.update!(profile_params)
    end

    let(:call_api) { delete :delete_profile_categories_data, params: {deleted_category_ids: BxBlockCategories::Category.all.ids} }
    let(:profile_params) {{
      category_ids: BxBlockCategories::Category.all.ids,
      profile_attributes: {
        # k12
        board_id: board.id,
        school_name: school_name,
        standard_id: standard.id,
        subject_ids: [subject.id],

        # higher_education
        degree_id: degree.id,
        specialization_id: specialization.id,
        educational_course_id: educational_course.id,
        college_id: college.id,
        college_name: college_name,
        passing_year: passing_year,

        # competitive_exam
        higher_education_level_id: education_level.id,
        competitive_exam_degree_id: degree.id,
        competitive_exam_specialization_id: specialization.id,
        competitive_exam_course_id: educational_course.id,
        competitive_exam_college_id: college.id,
        competitive_exam_college_name: college_name,
        competitive_exam_passing_year: passing_year,
        competitive_exam_board_id: board.id,
        competitive_exam_school_name: school_name,
        competitive_exam_standard_id: standard.id,
        competitive_exam_subject_ids: [subject.id],

        # govt_job
        govt_job_attributes: {
          education_level_id: education_level.id,
          specialization_id: specialization.id,
          caste_category: caste_category,
        },

        # upskilling
        education_level_profiles_attributes: [{
          education_level_id: education_level.id,
          board_id: board.id,
          specialization_id: specialization.id,
          standard_id: standard.id,
          school_name: school_name,
          degree_id: degree.id,
          college_id: college.id,
          college_name: college_name,
          educational_course_id: educational_course.id,
          passing_year: passing_year,
          subject_ids: [subject.id],
        }],

        certifications_attributes: [{
          certification_course_name: certification_course_name,
          provided_by: provided_by,
          duration: duration,
          completion_year: completion_year,
        }],

        employment_details_attributes: [{
          last_employer: last_employer,
          designation: designation,
          domain_work_function_id: domain_work_function.id,
        }]
      }
    }}

    def before_response
      expect(account.reload.category_ids).to match_array(BxBlockCategories::Category.all.ids)

      # k12
      expect(account.profile.board_id).not_to be_nil
      expect(account.profile.school_name).not_to be_nil
      expect(account.profile.standard_id).not_to be_nil
      expect(account.profile.subject_ids).not_to eq([])

      # higher_education
      expect(account.profile.degree_id).not_to be_nil
      expect(account.profile.specialization_id).not_to be_nil
      expect(account.profile.educational_course_id).not_to be_nil
      expect(account.profile.college_id).not_to be_nil
      expect(account.profile.college_name).not_to be_nil
      expect(account.profile.passing_year).not_to be_nil

      # competitive_exam
      expect(account.profile.higher_education_level_id).not_to be_nil
      expect(account.profile.competitive_exam_degree_id).not_to be_nil
      expect(account.profile.competitive_exam_specialization_id).not_to be_nil
      expect(account.profile.competitive_exam_course_id).not_to be_nil
      expect(account.profile.competitive_exam_college_id).not_to be_nil
      expect(account.profile.competitive_exam_college_name).not_to be_nil
      expect(account.profile.competitive_exam_passing_year).not_to be_nil
      expect(account.profile.competitive_exam_board_id).not_to be_nil
      expect(account.profile.competitive_exam_school_name).not_to be_nil
      expect(account.profile.competitive_exam_standard_id).not_to be_nil
      expect(account.profile.competitive_exam_subject_ids).not_to eq([])

      # govt_job
      expect(account.profile.govt_job).not_to be_nil

      # upskilling
      expect(account.profile.certification_profiles).not_to eq([])
      expect(account.profile.employment_detail_profiles).not_to eq([])
      expect(account.profile.education_level_profiles).not_to eq([])
    end

    def after_response
      expect(account.reload.category_ids).to eq([])

      # k12
      expect(account.profile.board_id).to be_nil
      expect(account.profile.school_name).to be_nil
      expect(account.profile.standard_id).to be_nil
      expect(account.profile.subject_ids).to eq([])

      # higher_education
      expect(account.profile.degree_id).to be_nil
      expect(account.profile.specialization_id).to be_nil
      expect(account.profile.educational_course_id).to be_nil
      expect(account.profile.college_id).to be_nil
      expect(account.profile.college_name).to be_nil
      expect(account.profile.passing_year).to be_nil

      # competitive_exam
      expect(account.profile.higher_education_level_id).to be_nil
      expect(account.profile.competitive_exam_degree_id).to be_nil
      expect(account.profile.competitive_exam_specialization_id).to be_nil
      expect(account.profile.competitive_exam_course_id).to be_nil
      expect(account.profile.competitive_exam_college_id).to be_nil
      expect(account.profile.competitive_exam_college_name).to be_nil
      expect(account.profile.competitive_exam_passing_year).to be_nil
      expect(account.profile.competitive_exam_board_id).to be_nil
      expect(account.profile.competitive_exam_school_name).to be_nil
      expect(account.profile.competitive_exam_standard_id).to be_nil
      expect(account.profile.competitive_exam_subject_ids).to eq([])

      # govt_job
      expect(account.profile.govt_job).to be_nil

      # upskilling
      expect(account.profile.certification_profiles).to eq([])
      expect(account.profile.employment_detail_profiles).to eq([])
      expect(account.profile.education_level_profiles).to eq([])
    end

    it 'should return http status 200' do
      call_api
      expect(success_response)
    end

    it 'should correct response' do
      expect(before_response)
      call_api
      expect(after_response)
    end
  end
end
