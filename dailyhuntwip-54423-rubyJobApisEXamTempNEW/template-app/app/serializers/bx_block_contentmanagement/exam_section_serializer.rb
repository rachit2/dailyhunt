module BxBlockContentmanagement
  class ExamSectionSerializer < BuilderBase::BaseSerializer
    attributes :id, :title, :body, :created_at, :updated_at
    
  end
end
