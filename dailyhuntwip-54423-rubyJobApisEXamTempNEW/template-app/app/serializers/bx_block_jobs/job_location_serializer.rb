class BxBlockJobs::JobLocationSerializer
  include JSONAPI::Serializer

  attributes :id, :latitude, :longitude, :city, :state,:country

end
