# frozen_string_literal: true

module CanListFilesOnAws
  def list_files_in_aws_bucket(directory_name, options = {})
    s3_result = nil

    3.times do
      s3_result = bucket.list_files(directory_name, options)

      break if s3_result.successful?
    end

    raise(s3_result.error) unless s3_result.successful?

    s3_result.result
  end

  def bucket
    @_bucket ||= DefraRuby::Aws.get_bucket(bucket_name)
  end
end
