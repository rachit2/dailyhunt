require 'rails_helper'
include ActionDispatch::TestProcess
include StubHelper

RSpec.describe BxBlockBulkUpload::XmlIndexContentService, type: :services do

  it 'should create content_types' do
    stub_reques

    response = BxBlockBulkUpload::XmlIndexContentService.create_content
    expect(response[:success]).to eq(true)
    expect(BxBlockContentmanagement::Content.count).to eq(122)
  end
end
