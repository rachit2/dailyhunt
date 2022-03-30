include ActionDispatch::TestProcess
FactoryBot.define do
  factory :long_video, class: BxBlockVideos::Video do
    video { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'long_video.mp4'), 'video/mp4') }
  end
end
