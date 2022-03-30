module BxBlockContentmanagement
  class ExamUpdateSerializer < BuilderBase::BaseSerializer
    attributes :id, :update_message, :link, :date
  end
end