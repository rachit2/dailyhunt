require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.production?
    config.fog_provider = 'fog/aws'
    config.storage :fog
    config.cache_storage = :fog
    config.fog_directory  = ENV['STORAGE_BUCKET']
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['STORAGE_ACCESS_KEY'],
      aws_secret_access_key: ENV['STORAGE_SECRET_ACCESS_KEY'],
      path_style: true,
      region: ENV['STORAGE_REGION'],
      host: 'minio',
      endpoint: ENV['STORAGE_ENDPOINT']
    }
  else
    config.storage    = :file
  end

end

CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
