# frozen_string_literal: true

require "defra_ruby/aws"

# rubocop:disable Metrics/BlockLength
DefraRuby::Aws.configure do |c|
  epr_bucket = {
    name: ENV.fetch("AWS_DAILY_EXPORT_BUCKET", nil),
    region: ENV.fetch("AWS_REGION", nil),
    credentials: {
      access_key_id: ENV.fetch("AWS_DAILY_EXPORT_ACCESS_KEY_ID", nil),
      secret_access_key: ENV.fetch("AWS_DAILY_EXPORT_SECRET_ACCESS_KEY", nil)
    },
    encrypt_with_kms: ENV.fetch("AWS_DAILY_ENCRYPT_WITH_KMS", nil)
  }

  boxy_bucket = {
    name: ENV.fetch("AWS_BOXI_EXPORT_BUCKET", nil),
    region: ENV.fetch("AWS_REGION", nil),
    credentials: {
      access_key_id: ENV.fetch("AWS_BOXI_EXPORT_ACCESS_KEY_ID", nil),
      secret_access_key: ENV.fetch("AWS_BOXI_EXPORT_SECRET_ACCESS_KEY", nil)
    },
    encrypt_with_kms: ENV.fetch("AWS_BOXI_ENCRYPT_WITH_KMS", nil)
  }

  weekly_exports_bucket = {
    name: ENV.fetch("AWS_WEEKLY_EXPORT_BUCKET", nil),
    region: ENV.fetch("AWS_REGION", nil),
    credentials: {
      access_key_id: ENV.fetch("AWS_WEEKLY_EXPORT_ACCESS_KEY_ID", nil),
      secret_access_key: ENV.fetch("AWS_WEEKLY_EXPORT_SECRET_ACCESS_KEY", nil)
    },
    encrypt_with_kms: ENV.fetch("AWS_WEEKLY_ENCRYPT_WITH_KMS", nil)
  }

  c.buckets = [boxy_bucket, epr_bucket, weekly_exports_bucket]
end
# rubocop:enable Metrics/BlockLength
