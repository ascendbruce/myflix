CarrierWave.configure do |config|
  if Rails.env.production? || Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      :provider               => "AWS",
      :aws_access_key_id      => ENV["AWS_ACCESS_KEY_ID"],
      :aws_secret_access_key  => ENV["AWS_SECRET_ACCESS_KEY"],
      :region                 => 'us-west-2'
    }
    config.fog_directory  = 'ascendbruce-myflix-oregon'
  else
    config.storage :file
    config.enable_processing = Rails.env.development?
  end
end
