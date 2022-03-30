module BxBlockContentmanagement
  class ErrorSerializer < BuilderBase::BaseSerializer
    attribute :errors do |follow|
      follow.errors.as_json
    end
  end
end
