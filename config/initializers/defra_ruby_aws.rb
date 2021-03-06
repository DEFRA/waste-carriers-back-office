# frozen_string_literal: true

require "defra_ruby/aws"

DefraRuby::Aws.configure do |c|
  epr_bucket = {
    name: ENV["AWS_DAILY_EXPORT_BUCKET"],
    region: ENV["AWS_REGION"],
    credentials: {
      access_key_id: ENV["AWS_DAILY_EXPORT_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_DAILY_EXPORT_SECRET_ACCESS_KEY"]
    },
    encrypt_with_kms: ENV["AWS_DAILY_ENCRYPT_WITH_KMS"]
  }

  boxy_bucket = {
    name: ENV["AWS_BOXI_EXPORT_BUCKET"],
    region: ENV["AWS_REGION"],
    credentials: {
      access_key_id: ENV["AWS_BOXI_EXPORT_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_BOXI_EXPORT_SECRET_ACCESS_KEY"]
    },
    encrypt_with_kms: ENV["AWS_BOXI_ENCRYPT_WITH_KMS"]
  }

  c.buckets = [boxy_bucket, epr_bucket]
end
