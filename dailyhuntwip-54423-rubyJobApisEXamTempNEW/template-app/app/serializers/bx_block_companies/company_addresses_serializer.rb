class BxBlockCompanies::CompanyAddressesSerializer
  include JSONAPI::Serializer
  attributes :id, :address, :company_id

end
