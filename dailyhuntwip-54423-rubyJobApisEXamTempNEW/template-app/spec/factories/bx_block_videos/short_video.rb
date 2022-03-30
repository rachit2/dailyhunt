include ActionDispatch::TestProcess
FactoryBot.define do
  factory :short_video, class: BxBlockVideos::Video do
    video { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'short.mov'), 'video/mov') }
  end
end
