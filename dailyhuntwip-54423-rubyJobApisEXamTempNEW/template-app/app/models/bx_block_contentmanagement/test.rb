# == Schema Information
#
# Table name: tests
#
#  id          :bigint           not null, primary key
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  headline    :string
#
module BxBlockContentmanagement
  class Test < ApplicationRecord
    include Contentable

    self.table_name = :tests

    validates_presence_of :headline, :description

    def name
      headline
    end

    def image_url
      nil
    end

    def video_url
      nil
    end

    def audio_url
      nil
    end

    def study_material_url
      nil
    end

    rails_admin do
      configure :description do
        pretty_value do
          value.html_safe
        end
      end
    end
  end
end
