module BxBlockProfile
  class TotalFeesSerializer < BuilderBase::BaseSerializer
    attributes :id, :min, :max, :is_active, :created_at, :updated_at
  end
end