require 'rails_helper'
include ActionDispatch::TestProcess
include StubHelper

RSpec.describe BxBlockBulkUpload::XmlDetailContentService, type: :services do
  it 'should show content' do
    stub_reques

    BxBlockBulkUpload::XmlIndexContentService.create_content
    detail_content = BxBlockContentmanagement::Content.find_by(crm_id: 30547)
    response = BxBlockBulkUpload::XmlDetailContentService.create_content(detail_content.id)
    expect(response[:success]).to eq(true)
  end
end
