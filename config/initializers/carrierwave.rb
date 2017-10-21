CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_KEY_JPHACKS'],
    aws_secret_access_key: ENV['AWS_ACCESS_KEY_JPHACKS'],
    region: ENV['AWS_REASION_JPHACK']
  }

  config.fog_directory  = ENV['AWS_BUCKET_NAME_JPHACKS']
  config.cache_storage = :fog
end
