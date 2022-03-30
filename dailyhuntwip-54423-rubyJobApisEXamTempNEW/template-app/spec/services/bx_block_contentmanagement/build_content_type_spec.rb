require 'rails_helper'

RSpec.describe BxBlockContentmanagement::BuildContentType, type: :services do
  let(:expected_content_types){[
    {name: "News Articles", type: "Text", identifier: "news_article"},
    {name: "Blogs", type: "Text", identifier: "blog"},
    {name: "Videos (short)", type: "Videos", identifier: "video_short"},
    {name: "Videos (full length)", type: "Videos", identifier: "video_full"},
    {name: "Live Streaming", type: "Live Stream", identifier: "live_streaming"},
    {name: "Audio Podcast", type: "AudioPodcast", identifier: "audio_podcast"},
    {name: "Study Materials (PDFs/ PPTs/ Word)", type: "Epub", identifier: "study_material"}
  ]}

  it 'should create content_types' do
    expect(BxBlockContentmanagement::ContentType.count).to eq(0)
    expect{
      BxBlockContentmanagement::BuildContentType.call
    }.to change{ BxBlockContentmanagement::ContentType.count }.by(7)

    content_types = BxBlockContentmanagement::ContentType.all.map{|ct| {name: ct.name, type: ct.type, identifier: ct.identifier} }
    expect(content_types).to match_array(expected_content_types)
  end
end
