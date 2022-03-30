# == Schema Information
#
# Table name: lessions
#
#  id          :bigint           not null, primary key
#  description :text
#  heading     :string
#  rank        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  course_id   :bigint           not null
#
# Indexes
#
#  index_lessions_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
module BxBlockContentmanagement
  class LessionSerializer < BuilderBase::BaseSerializer
    attributes :id, :heading, :description, :rank, :lession_contents, :created_at, :updated_at
    attribute :lession_contents do |object, params|
      BxBlockContentmanagement::LessionContentSerializer.new(object.lession_contents, {params: { paid: params[:paid], free_trail: params[:free_trail], read_lessions_ids: params[:read_lessions_ids] }})
    end
  end
end
