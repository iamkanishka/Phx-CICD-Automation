defmodule PhxCicdAutomation.Aws.S3ServerFiles do

  alias ExAws.S3

  @bucket "your-s3-bucket-name"

  def get_s3_url(s3_key) do
    "https://#{@bucket}.s3.amazonaws.com/#{s3_key}"
  end

  def get_presigned_url(s3_key) do
    S3.presigned_url(:get, @bucket, s3_key, expires_in: 3600)
  end

end
