module BxBlockCommunityforum
  class ErrorSerializer < BuilderBase::BaseSerializer
    attribute :errors do |error|
      error.errors.as_json
    end
  end
end
