require "carrierwave/storage/abstract"
require "carrierwave/storage/file"
require "carrierwave/storage/fog"

CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage  = :fog
    config.fog_provider = "fog/aws"                                # 必須
    config.fog_directory  = ENV["S3_BUCKET_NAME"]                  # バケット名
    config.fog_public     = false                                  # アクセス権限
    config.fog_credentials = {
      provider:              "AWS",                                # 必須
      aws_access_key_id:     ENV["S3_ACCESS_KEY_ID"],              # 環境変数から取得
      aws_secret_access_key: ENV["S3_SECRET_ACCESS_KEY"],          # 環境変数から取得
      region:                ENV["S3_REGION"],                     # 環境変数から取得
      path_style: true
    }
  else
    config.storage :file
    config.enable_processing = false if Rails.env.test?
  end
end
